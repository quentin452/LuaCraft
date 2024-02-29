function initScene()
	_JPROFILER.push("initScene")

	Scene = Engine.newScene(GraphicsWidth, GraphicsHeight)
	Scene.camera.perspective = TransposeMatrix(
		cpml.mat4.from_perspective(90, love.graphics.getWidth() / love.graphics.getHeight(), 0.001, 10000)
	)
	if enablePROFIProfiler then
		ProFi:checkMemory(1, "Premier profil")
	end
	_JPROFILER.pop("initScene")
end

function initGlobalRandomNumbers()
	_JPROFILER.push("initGlobalRandomNumbers")

	Salt = {}
	for i = 1, 128 do
		Salt[i] = love.math.random()
	end
	if enablePROFIProfiler then
		ProFi:checkMemory(2, "Second profil")
	end
	_JPROFILER.pop("initGlobalRandomNumbers")
end

function initEntities()
	_JPROFILER.push("initEntities")

	initEntityList()
	initPlayerInventory()
	if enablePROFIProfiler then
		ProFi:checkMemory(3, "Troisième profil")
	end
	_JPROFILER.pop("initEntities")
end

function initEntityList()
	_JPROFILER.push("initEntityList")

	ThingList = {}
	ThePlayer = CreateThing(NewPlayer(0, 128, 0))
	if enablePROFIProfiler then
		ProFi:checkMemory(4, "4eme profil")
	end
	_JPROFILER.pop("initEntityList")
end

function initPlayerInventory()
	_JPROFILER.push("initPlayerInventory")

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
	_JPROFILER.pop("initPlayerInventory")
end

function GenerateWorld()
	_JPROFILER.push("GenerateWorld")

	initScene()
	initGlobalRandomNumbers()
	initEntities()
	if enablePROFIProfiler then
		ProFi:checkMemory(9, "9eme profil")
	end
	_JPROFILER.pop("GenerateWorld")
end

-- convert an index into a point on a 2d plane of given width and height
coordCache = {}

function NumberToCoord(n, w, h)
	--	_JPROFILER.push("NumberToCoord")

	local key = tostring(n) .. ":" .. tostring(w) .. ":" .. tostring(h)
	if coordCache[key] then
		return unpack(coordCache[key])
	end

	local y = math.floor(n / w)
	local x = n - (y * w)
	coordCache[key] = { x, y }
	--	_JPROFILER.pop("NumberToCoord")

	return x, y
end

-- hash function used in chunk hash table
function ChunkHash(x)
	return x < 0 and 2 * math.abs(x) or 1 + 2 * x
end

function Localize(x, y, z)
	return x % ChunkSize + 1, y, z % ChunkSize + 1
end
function Globalize(cx, cz, x, y, z)
	return (cx - 1) * ChunkSize + x - 1, y, (cz - 1) * ChunkSize + z - 1
end

-- get chunk from reading chunk hash table at given position
function GetChunk(x, y, z)
	--	_JPROFILER.push("GetChunk")

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
	--	_JPROFILER.pop("GetChunk")

	return getChunk, mx, y, mz, hashx, hashy
end

function GetChunkRaw(x, z)
	_JPROFILER.push("GetChunkRaw")

	local hashx, hashy = ChunkHash(x), ChunkHash(z)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	_JPROFILER.pop("GetChunkRaw")

	return getChunk
end

-- get voxel by looking at chunk at given position's local coordinate system
function GetVoxel(x, y, z)
	--	_JPROFILER.push("GetVoxel")

	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local v = 0
	if chunk ~= nil then
		v = chunk:getVoxel(cx, cy, cz)
	end
	--	_JPROFILER.pop("GetVoxel")

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
	--_JPROFILER.push("SetVoxelFirstData")

	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelFirstData(cx, cy, cz, value)
		return true
	end
	--_JPROFILER.pop("SetVoxelFirstData")

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
