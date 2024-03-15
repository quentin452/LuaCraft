local playerReach = 5

function NewPlayer(x, y, z)
	_JPROFILER.push("NewPlayer")
	local t = NewThing(x, y, z)
	t.friction = 0.85
	t.moveSpeed = 0.01
	t.viewBob = 0
	t.viewBobMult = 0
	t.name = "player"
	t.cursorpos = {}
	t.cursorposPrev = {}
	t.onGround = false
	t.height = 1.85
	t.eyeLevel = 1.62
	t.width = 0.25
	t.rotation = 0
	t.pitch = 0
	t.IsPlayerHasSpawned = false

	t.update = function(self, dt)
		_JPROFILER.push("NewPlayer_update")
		if PhysicsStep then
			self:physics()
		end

		-- view bobbing
		local speed = math.dist(0, 0, self.xSpeed, self.zSpeed)
		self.viewBob = self.viewBob + speed * 2.75 * (dt * 60)
		self.viewBobMult = math.min(speed, 1)

		-- update camera position to the new player position
		Scene.camera.pos.x, Scene.camera.pos.y, Scene.camera.pos.z =
			self.x, self.y + math.sin(self.viewBob) * self.viewBobMult * 1 + self.eyeLevel, self.z

		-- update voxel cursor position to whatever block is currently being pointed at
		local rx, ry, rz = Scene.camera.pos.x, Scene.camera.pos.y, Scene.camera.pos.z
		local step = 0.1
		self.cursorHit = false

		for i = 1, playerReach, step do
			local chunk, cx, cy, cz, hashx, hashy = GetChunk(rx, ry, rz)
			if chunk and chunk:getVoxel(cx, cy, cz) ~= 0 then
				self.cursorpos = { x = cx, y = cy, z = cz, chunk = chunk }
				self.cursorHit = true
				break
			end
			self.cursorposPrev = { x = cx, y = cy, z = cz, chunk = chunk }

			rx = rx + math.cos(Scene.camera.angle.x - math.pi / 2) * step * math.cos(Scene.camera.angle.y)
			rz = rz + math.sin(Scene.camera.angle.x - math.pi / 2) * step * math.cos(Scene.camera.angle.y)
			ry = ry - math.sin(Scene.camera.angle.y) * step
		end

		-- Update rotation and pitch
		self.rotation, self.pitch = Scene.camera.angle.x, Scene.camera.angle.y
		_JPROFILER.pop("NewPlayer_update")
		return true
	end

	t.physics = function(self)
		_JPROFILER.push("NewPlayer_physics")
		local Camera = Scene.camera

		-- apply gravity and friction
		self.xSpeed = self.xSpeed * self.friction
		self.zSpeed = self.zSpeed * self.friction
		self.ySpeed = self.ySpeed - 0.009

		-- determine if player has hit ground this frame
		self.onGround = false
		if
			TileCollisions(GetVoxel(self.x + self.width, self.y + self.ySpeed, self.z + self.width))
			or TileCollisions(GetVoxel(self.x + self.width, self.y + self.ySpeed, self.z - self.width))
			or TileCollisions(GetVoxel(self.x - self.width, self.y + self.ySpeed, self.z + self.width))
			or TileCollisions(GetVoxel(self.x - self.width, self.y + self.ySpeed, self.z - self.width))
		then
			local i = 0
			while
				not TileCollisions(GetVoxel(self.x + self.width, self.y + i, self.z + self.width))
				and not TileCollisions(GetVoxel(self.x + self.width, self.y + i, self.z - self.width))
				and not TileCollisions(GetVoxel(self.x - self.width, self.y + i, self.z + self.width))
				and not TileCollisions(GetVoxel(self.x - self.width, self.y + i, self.z - self.width))
			do
				i = i - 0.01
			end
			self.y = self.y + i + 0.01
			self.ySpeed = 0
			self.onGround = true
		end

		local mx, my = 0, 0
		local moving = false

		-- take player input
		if fixinputforDrawCommandInput == false then
			local directionKeys = {
				z = { 0, -1 },
				q = { -1, 0 },
				s = { 0, 1 },
				d = { 1, 0 },
			}

			for key, dir in pairs(directionKeys) do
				if love.keyboard.isDown(key) then
					mx = mx + dir[1]
					my = my + dir[2]
					moving = true
				end
			end

			-- jump if on ground
			if
				love.keyboard.isDown("space")
				and self.onGround
				and not TileCollisions(GetVoxel(self.x, self.y + self.height + 1, self.z))
			then
				self.ySpeed = self.ySpeed + 0.15
			end
		end

		-- hit head ceilings
		if
			math.abs(self.ySpeed) == self.ySpeed
			and (
				TileCollisions(GetVoxel(self.x - self.width, self.y + self.height + self.ySpeed, self.z + self.width))
				or TileCollisions(
					GetVoxel(self.x - self.width, self.y + self.height + self.ySpeed, self.z - self.width)
				)
				or TileCollisions(
					GetVoxel(self.x + self.width, self.y + self.height + self.ySpeed, self.z + self.width)
				)
				or TileCollisions(
					GetVoxel(self.x + self.width, self.y + self.height + self.ySpeed, self.z - self.width)
				)
			)
		then
			self.ySpeed = -0.5 * self.ySpeed
		end

		-- convert WASD keys pressed into an angle, move xSpeed and zSpeed according to cos and sin
		if moving then
			local angle = math.angle(0, 0, mx, my)
			self.direction = (Camera.angle.x + angle) * -1 + math.pi / 2
			self.xSpeed = self.xSpeed + math.cos(Camera.angle.x + angle) * self.moveSpeed
			self.zSpeed = self.zSpeed + math.sin(Camera.angle.x + angle) * self.moveSpeed
		end

		-- y values are good, cement them
		self.y = self.y + self.ySpeed

		-- check for collisions with walls along the x direction
		if
			not TileCollisions(
				GetVoxel(self.x + self.xSpeed + GetSign(self.xSpeed) * self.width, self.y, self.z - self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x + self.xSpeed + GetSign(self.xSpeed) * self.width, self.y + 1, self.z - self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x + self.xSpeed + GetSign(self.xSpeed) * self.width, self.y, self.z + self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x + self.xSpeed + GetSign(self.xSpeed) * self.width, self.y + 1, self.z + self.width)
			)
		then
			-- x values are good, cement them
			self.x = self.x + self.xSpeed
		else
			self.xSpeed = 0
		end

		-- check for collisions with walls along the z direction
		if
			not TileCollisions(
				GetVoxel(self.x - self.width, self.y, self.z + self.zSpeed + GetSign(self.zSpeed) * self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x - self.width, self.y + 1, self.z + self.zSpeed + GetSign(self.zSpeed) * self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x + self.width, self.y, self.z + self.zSpeed + GetSign(self.zSpeed) * self.width)
			)
			and not TileCollisions(
				GetVoxel(self.x + self.width, self.y + 1, self.z + self.zSpeed + GetSign(self.zSpeed) * self.width)
			)
		then
			-- z values are good, cement them
			self.z = self.z + self.zSpeed
		else
			self.zSpeed = 0
		end
		_JPROFILER.pop("NewPlayer_physics")
	end
	_JPROFILER.pop("NewPlayer")
	return t
end

function PlayerInit()
	_JPROFILER.push("PlayerInit")
	ThePlayer = CreateThing(NewPlayer(0, 0, 0))
	initPlayerInventory()
	_JPROFILER.pop("PlayerInit")
end
function FindSolidBlock(x, y, z)
	_JPROFILER.push("FindSolidBlock")
	while y > 0 and GetVoxel(x, y, z) == 0 do
		y = y - 1
	end
	_JPROFILER.pop("FindSolidBlock")
	return y
end

local function GenerateRandomPosition()
	return math.random() * 120
end

function ChooseSpawnLocation()
	_JPROFILER.push("ChooseSpawnLocation")
	local maxTries = 1000
	local currentTry = 0
	local foundSolidBlock = false
	local playerX
	local playerY
	local playerZ
	while not foundSolidBlock and currentTry < maxTries do
		playerX = GenerateRandomPosition()
		playerZ = GenerateRandomPosition()
		playerY = WorldHeight

		playerY = FindSolidBlock(playerX, playerY, playerZ)

		if playerY > 0 then
			foundSolidBlock = true
		else
			currentTry = currentTry + 1
			if currentTry % 100 == 0 then
				LuaCraftPrintLoggingNormal("Still trying to find a suitable spawn position... Try #" .. currentTry)
			end
		end
	end

	if not foundSolidBlock then
		LuaCraftErrorLogging("Warning: Unable to find a suitable spawn position after " .. maxTries .. " tries.")
		_JPROFILER.pop("ChooseSpawnLocation")
		return
	end

	-- Change the player's position to the calculated position
	ThePlayer.x = playerX
	ThePlayer.y = playerY + 1.1
	ThePlayer.z = playerZ
	ThePlayer.IsPlayerHasSpawned = true
	_JPROFILER.pop("ChooseSpawnLocation")
end

function initPlayerInventory()
	_JPROFILER.push("initPlayerInventory")
	local defaultTileIDs = {
		Tiles.STONE_Block.id,
		Tiles.COBBLE_Block.id,
		Tiles.GRASS_Block.id,
		Tiles.YELLO_FLOWER_Block.id,
		Tiles.OAK_SAPPLING_Block.id,
		Tiles.OAK_LOG_Block.id,
		Tiles.OAK_LEAVE_Block.id,
		Tiles.SAND_Block.id,
		Tiles.GLOWSTONE_Block.id,
	}
	for i = 1, 36 do
		PlayerInventory.items[i] = defaultTileIDs[i] or Tiles.AIR_Block.id
	end
	_JPROFILER.pop("initPlayerInventory")
end

function getPlayerPosition()
	_JPROFILER.push("getPlayerPosition")
	_JPROFILER.pop("getPlayerPosition")
	return {
		x = math.floor(ThePlayer.x + 0.5),
		y = math.floor(ThePlayer.y + 0.5),
		z = math.floor(ThePlayer.z + 0.5),
	}
end
