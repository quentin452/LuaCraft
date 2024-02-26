function initScene()
	Scene = Engine.newScene(GraphicsWidth, GraphicsHeight)
	Scene.camera.perspective = TransposeMatrix(
		cpml.mat4.from_perspective(90, love.graphics.getWidth() / love.graphics.getHeight(), 0.001, 10000)
	)
	if enablePROFIProfiler then
		ProFi:checkMemory(1, "Premier profil")
	end
end

function initGlobalRandomNumbers()
	Salt = {}
	for i = 1, 128 do
		Salt[i] = love.math.random()
	end
	if enablePROFIProfiler then
		ProFi:checkMemory(2, "Second profil")
	end
end

function initEntities()
	initEntityList()
	initPlayerInventory()
	if enablePROFIProfiler then
		ProFi:checkMemory(3, "Troisième profil")
	end
end

function initEntityList()
	ThingList = {}
	ThePlayer = CreateThing(NewPlayer(0, 128, 0))
	if enablePROFIProfiler then
		ProFi:checkMemory(4, "4eme profil")
	end
end

function initPlayerInventory()
	PlayerInventory = {
		items = {},
		hotbarSelect = 1,
	}

	local defaultItems = {
		__STONE_Block,
		__COBBLE_Block,
		__STONE_BRICK_Block,
		__YELLO_FLOWER_Block,
		__OAK_SAPPLING_Block,
		__OAK_LOG_BLock,
		__OAK_LEAVE_BLock,
		__GLASS_BLock,
		__GLOWSTONE_BLock,
	}
	for i = 1, 36 do
		PlayerInventory.items[i] = defaultItems[i] or 0
	end
	if enablePROFIProfiler then
		ProFi:checkMemory(5, "5eme profil")
	end
end

function generateWorldChunks()
	ChunkHashTable = {}
	ChunkSet = {}
	ChunkRequests = {}
	LightingQueue = {}
	LightingRemovalQueue = {}
	CaveList = {}
	local worldSize = 4

	StartTime = love.timer.getTime()
	MeasureTime = StartTime

	for i = worldSize / -2 + 1, worldSize / 2 do
		ChunkHashTable[ChunkHash(i)] = {}
		for j = worldSize / -2 + 1, worldSize / 2 do
			local chunk = NewChunk(i, j)
			ChunkSet[chunk] = true
			ChunkHashTable[ChunkHash(i)][ChunkHash(j)] = chunk

			-- Ajoutez des prints pour déboguer
			LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", i, j)
		end
	end
	if enablePROFIProfiler then
		ProFi:checkMemory(6, "6eme profil")
	end
end

function updateWorld()
	UpdateCaves()
	if enablePROFIProfiler then
		ProFi:checkMemory(7, "7eme profil")
	end
end

function updateLighting()
	for chunk in pairs(ChunkSet) do
		chunk:sunlight()
	end

	for chunk in pairs(ChunkSet) do
		chunk:populate()
	end

	for chunk in pairs(ChunkSet) do
		chunk:processRequests()
		chunk:initialize()
	end

	if enablePROFIProfiler then
		ProFi:checkMemory(8, "8eme profil")
	end
end

function printGenerationTime()
	LuaCraftPrintLoggingNormal("total generation time: " .. (love.timer.getTime() - StartTime))
end

function GenerateWorld()
	initScene()
	initGlobalRandomNumbers()
	initEntities()
	generateWorldChunks()
	updateWorld()
	printGenerationTime()
	updateLighting()
	if enablePROFIProfiler then
		ProFi:checkMemory(9, "9eme profil")
	end
end

-- convert an index into a point on a 2d plane of given width and height
function NumberToCoord(n, w, h)
	local y = math.floor(n / w)
	local x = n - (y * w)

	return x, y
end

-- hash function used in chunk hash table
function ChunkHash(x)
	if x < 0 then
		return math.abs(2 * x)
	end

	return 1 + 2 * x
end

function Localize(x, y, z)
	return x % ChunkSize + 1, y, z % ChunkSize + 1
end
function Globalize(cx, cz, x, y, z)
	return (cx - 1) * ChunkSize + x - 1, y, (cz - 1) * ChunkSize + z - 1
end

function ToChunkCoords(x, z)
	return math.floor(x / ChunkSize) + 1, math.floor(z / ChunkSize) + 1
end

-- get chunk from reading chunk hash table at given position
function GetChunk(x, y, z)
	local x = math.floor(x)
	local y = math.floor(y)
	local z = math.floor(z)
	local hashx, hashy = ChunkHash(math.floor(x / ChunkSize) + 1), ChunkHash(math.floor(z / ChunkSize) + 1)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	if y < 1 or y > WorldHeight then
		getChunk = nil
	end

	local mx, mz = x % ChunkSize + 1, z % ChunkSize + 1

	return getChunk, mx, y, mz, hashx, hashy
end

function GetChunkRaw(x, z)
	local hashx, hashy = ChunkHash(x), ChunkHash(z)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end

	return getChunk
end

-- get voxel by looking at chunk at given position's local coordinate system
function GetVoxel(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local v = 0
	if chunk ~= nil then
		v = chunk:getVoxel(cx, cy, cz)
	end
	return v
end
function GetVoxelData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local v = 0
	local d = 0
	if chunk ~= nil then
		v, d = chunk:getVoxel(cx, cy, cz)
	end
	return d
end

function GetVoxelFirstData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		return chunk:getVoxelFirstData(cx, cy, cz)
	end
	return 0
end

function GetVoxelSecondData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		return chunk:getVoxelSecondData(cx, cy, cz)
	end
	return 0
end

function SetVoxel(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxel(cx, cy, cz, value)
		return true
	end
	return false
end
function SetVoxelData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelData(cx, cy, cz, value)
		return true
	end
	return false
end

function SetVoxelFirstData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelFirstData(cx, cy, cz, value)
		return true
	end
	return false
end
function SetVoxelSecondData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelSecondData(cx, cy, cz, value)
		return true
	end
	return false
end

function UpdateChangedChunks()
	for chunk in pairs(ChunkSet) do
		if #chunk.changes > 0 then
			chunk:updateModel()
		end
	end
end
