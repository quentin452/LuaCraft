local playerReach = 5

function NewPlayer(x, y, z)
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

		return true
	end

	t.physics = function(self)
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
	end

	return t
end

function PlayerInit()
	ThePlayer = CreateThing(NewPlayer(0, 0, 0))
	initPlayerInventory()
end
function ChooseSpawnLocation()
	local maxTries = 1000
	local currentTry = 0

	-- Generate a random position for the player
	local playerX = math.random() * 120
	local playerZ = math.random() * 120

	-- Find the highest non-air voxel
	local playerY = WorldHeight
	local foundSolidBlock = false

	while not foundSolidBlock do
		while playerY > 0 and GetVoxel(playerX, playerY, playerZ) == 0 do
			playerY = playerY - 1
		end

		if playerY > 0 then
			foundSolidBlock = true
		else
			-- If no solid block was found, generate a new random position and try again
			playerX = math.random() * 120
			playerZ = math.random() * 120
			playerY = WorldHeight

			currentTry = currentTry + 1

			if currentTry >= maxTries then
				LuaCraftErrorLogging(
					"Warning: Unable to find a suitable spawn position after " .. maxTries .. " tries."
				)
			elseif currentTry % 100 == 0 then
				LuaCraftPrintLoggingNormal("Still trying to find a suitable spawn position... Try #" .. currentTry)
			end
		end
	end

	-- Change the player's position to the calculated position
	ThePlayer.x = playerX
	ThePlayer.y = playerY + 1.1
	ThePlayer.z = playerZ
	ThePlayer.IsPlayerHasSpawned = true
	currentTry = 0
end

function initPlayerInventory()
	_JPROFILER.push("initPlayerInventory")

	PlayerInventory = {
		items = {},
		hotbarSelect = 1,
	}

	local defaultItems = {
		Tiles.STONE_Block,
		Tiles.COBBLE_Block,
		Tiles.STONE_BRICK_Block,
		Tiles.YELLO_FLOWER_Block,
		Tiles.OAK_SAPPLING_Block,
		Tiles.OAK_LOG_Block,
		Tiles.OAK_LEAVE_Block,
		Tiles.SAND_Block,
		Tiles.GLOWSTONE_Block,
	}
	for i = 1, 36 do
		PlayerInventory.items[i] = defaultItems[i] or 0
	end
	if enablePROFIProfiler then
		ProFi:checkMemory(5, "5eme profil")
	end
	_JPROFILER.pop("initPlayerInventory")
end
