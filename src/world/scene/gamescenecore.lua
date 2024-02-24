GameScene = Object:extend()
local size
StructureMap = {}

gamescenetexturepack = lg.newImage("resources/assets/texturepack.png")
local wasLeftDown, wasRightDown, rightDown, leftDown

--Dependencies
require("src/world/scene/blockplacementandcursor")
require("src/world/scene/gamescenethreads")

function GameScene:init()
	size = Chunk.size
	self.thingList = {}
	self.chunkMap = {}
	self.remeshQueue = {}
	self.chunkCreationsThisFrame = 0
	self.updatedThisFrame = false
end

function GameScene:addThing(thing)
	_JPROFILER.push("GameScene:addThing")
	if not thing then
		return
	end
	table.insert(self.thingList, thing)
	_JPROFILER.pop("GameScene:addThing")
	return thing
end

function GameScene:removeThing(index)
	_JPROFILER.push("GameScene:removeThing")
	if not index then
		return
	end
	local thing = self.thingList[index]
	table.remove(self.thingList, index)
	_JPROFILER.pop("GameScene:removeThing")
	return thing
end

local function updateChunk(self, x, y, z)
	--TODO IMPROVE PERFORMANCES OF THIS
	_JPROFILER.push("updateChunk")
	x = x + math.floor(g3d.camera.position[1] / size)
	y = y + math.floor(g3d.camera.position[2] / size)
	z = z + math.floor(g3d.camera.position[3] / size)
	local hash = ("%d/%d/%d"):format(x, y, z)
	if self.chunkMap[hash] then
		self.chunkMap[hash].frames = 0
		self.chunkMap[hash].unloaded = false
	else
		local chunk = Chunk(x, y, z)
		self.chunkMap[hash] = chunk
		self.chunkMap[hash].unloaded = false
		self.chunkCreationsThisFrame = self.chunkCreationsThisFrame + 1

		-- this chunk was just created, so update all the chunks around it
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x + 1, y, z)])
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x - 1, y, z)])
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x, y + 1, z)])
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x, y - 1, z)])
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x, y, z + 1)])
		self:requestRemesh(self.chunkMap[("%d/%d/%d"):format(x, y, z - 1)])
	end
	_JPROFILER.pop("updateChunk")
end

function GameScene:update(dt)
	_JPROFILER.push("GameScene:update(ALL)")

	-- update all the things in the scene
	_JPROFILER.push("GameScene:update(RemoveDeadThings)")
	local i = 1
	while i <= #self.thingList do
		local thing = self.thingList[i]
		if not thing.dead then
			thing:update()
			i = i + 1
		else
			self:removeThing(i)
		end
	end
	_JPROFILER.pop("GameScene:update(RemoveDeadThings)")

	-- collect mouse inputs
	_JPROFILER.push("GameScene:update(DIVERS)")

	wasLeftDown, wasRightDown = leftDown, rightDown
	leftDown, rightDown = love.mouse.isDown(1), love.mouse.isDown(2)
	leftClick, rightClick = leftDown and not wasLeftDown, rightDown and not wasRightDown

	self.updatedThisFrame = true
	g3d.camera.firstPersonMovement(dt)
	_JPROFILER.pop("GameScene:update(DIVERS)")

	-- generate a "bubble" of loaded chunks around the camera
	_JPROFILER.push("GameScene:update(BUBBLEOFLOADEDCHUNKS)")
	local bubbleWidth = globalRenderDistance
	local bubbleHeight = math.floor(globalRenderDistance * 0.75)
	local creationLimit = 1
	self.chunkCreationsThisFrame = 0

	-- Precompute constants outside the loop
	local pi2 = math.pi * 2
	local halfPi = math.pi / 2

	for r = 0, bubbleWidth do
		local cosR = math.cos(r * halfPi / bubbleWidth)
		local h = math.floor(cosR * bubbleHeight + 0.5)

		for a = 0, pi2, pi2 / (8 * r) do
			local cosA, sinA = math.cos(a), math.sin(a)

			for y = 0, h do
				local x, z = math.floor(cosA * r + 0.5), math.floor(sinA * r + 0.5)
				updateChunk(self, x, y, z)
				if y ~= 0 then
					updateChunk(self, x, -y, z)
				end

				if self.chunkCreationsThisFrame >= creationLimit then
					break
				end
			end
		end
	end
	_JPROFILER.pop("GameScene:update(BUBBLEOFLOADEDCHUNKS)")

	ThreadCountGameScene(self, gamescenethreadusage)
	ListenFinishedMeshesOnthreadGameScene()

	RemeshChunkInQueueGameScene(self)
	LeftClickGameScene(self, size)
	RightClickGameScene(self, size)
	_JPROFILER.push("GameScene:update(GENSTRUCTUREFROMGAMESCENE)")
	for _, chunk in pairs(self.chunkMap) do
		-- Calculate the distance between the chunk and the camera
		local dist = math.sqrt(
			(chunk.x - g3d.camera.position[1]) ^ 2
				+ (chunk.y - g3d.camera.position[2]) ^ 2
				+ (chunk.z - g3d.camera.position[3]) ^ 2
		)

		if dist <= globalRenderDistance * Chunk.size then
			StructureGenFinal(self, size)
		end
	end

	_JPROFILER.pop("GameScene:update(GENSTRUCTUREFROMGAMESCENE)")

	_JPROFILER.pop("GameScene:update(ALL)")
	--TODO here add periodic chunk saving system
end

function GameScene:mousemoved(x, y, dx, dy)
	g3d.camera.firstPersonLook(dx, dy)
end

function GameScene:draw()
	_JPROFILER.push("GameScene:draw")
	lg.clear(lume.color("#4488ff"))

	-- draw all the things in the scene
	for _, thing in ipairs(self.thingList) do
		thing:draw()
	end

	lg.setColor(1, 1, 1)
	for _, chunk in pairs(self.chunkMap) do
		-- Calculate the distance between the chunk and the camera
		local dist = math.sqrt(
			(chunk.x - g3d.camera.position[1]) ^ 2
				+ (chunk.y - g3d.camera.position[2]) ^ 2
				+ (chunk.z - g3d.camera.position[3]) ^ 2
		)

		if dist <= globalRenderDistance * Chunk.size then
			-- Draw chunks only in the render distance
			chunk:draw()
		end
		if not chunk.unloaded and dist > globalRenderDistance * Chunk.size then
			self.chunkMap[_].unloaded = true
		end
	end

	self.updatedThisFrame = false

	CursorDrawingGameScene()

	if enableProfiler then
		ProFi:stop()
		ProFi:writeReport("report.txt")
	end

	_JPROFILER.pop("GameScene:draw")
end

function GameScene:getChunkFromWorld(x, y, z)
	_JPROFILER.push("GameScene:getChunkFromWorld")
	local floor = math.floor
	_JPROFILER.pop("GameScene:getChunkFromWorld")
	return self.chunkMap[("%d/%d/%d"):format(floor(x / size), floor(y / size), floor(z / size))]
end

function GameScene:getBlockFromWorld(x, y, z)
	_JPROFILER.push("GameScene:getBlockFromWorld")
	local floor = math.floor
	local chunk = self.chunkMap[("%d/%d/%d"):format(floor(x / size), floor(y / size), floor(z / size))]
	if chunk then
		return chunk:getBlock(x % size, y % size, z % size)
	end
	_JPROFILER.pop("GameScene:getBlockFromWorld")
	return -1
end

function GameScene:setBlockFromWorld(x, y, z, value)
	_JPROFILER.push("GameScene:setBlockFromWorld")
	local floor = math.floor
	local chunk = self.chunkMap[("%d/%d/%d"):format(floor(x / size), floor(y / size), floor(z / size))]
	if chunk then
		chunk:setBlock(x % size, y % size, z % size, value)
	end
	_JPROFILER.pop("GameScene:setBlockFromWorld")
end

function GameScene:requestRemesh(chunk, first)
	--_JPROFILER.push("GameScene:requestRemesh")
	-- don't add a nil chunk or a chunk that's already in the queue
	if not chunk then
		return
	end

	local x, y, z = chunk.cx, chunk.cy, chunk.cz
	local formatStr = "%d/%d/%d"
	local key1 = formatStr:format(x + 1, y, z)
	local key2 = formatStr:format(x - 1, y, z)
	local key3 = formatStr:format(x, y + 1, z)
	local key4 = formatStr:format(x, y - 1, z)
	local key5 = formatStr:format(x, y, z + 1)
	local key6 = formatStr:format(x, y, z - 1)

	if
		not self.chunkMap[key1]
		or not self.chunkMap[key2]
		or not self.chunkMap[key3]
		or not self.chunkMap[key4]
		or not self.chunkMap[key5]
		or not self.chunkMap[key6]
	then
		return
	end

	chunk.inRemeshQueue = true

	if first then
		table.insert(self.remeshQueue, 1, chunk)
	else
		table.insert(self.remeshQueue, chunk)
	end
	--_JPROFILER.pop("GameScene:requestRemesh")
end

function GameScene:destroy()
	self.thingList = nil
	self.chunkMap = nil
	self.remeshQueue = nil
	self.chunkCreationsThisFrame = nil
	gameSceneInstance = nil
end

function resetGameScene()
	if gameSceneInstance then
		gameSceneInstance:destroy()
		gameSceneInstance = nil
	end
end
