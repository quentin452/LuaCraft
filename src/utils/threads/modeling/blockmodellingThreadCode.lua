BlockModellingChannel, ChunkSize, ChunkHashTable, WorldHeight, TilesTextureList = ...

-- Cached voxel states
local getTop
local getBottom
local getPositiveX
local getNegativeX
local getPositiveZ
local getNegativeZ
-- Shared block vertices
local blockVertices = {}
local function TileTextures(n)
	return TilesTextureList[n]
end
-- Checks if a face can be drawn based on transparency
local function CanDrawFace(get, thisTransparency)
	local tileTransparency = TileTransparency(get)
	local result = true
	if tileTransparency == TilesTransparency.FULL then
		result = false
	elseif tileTransparency == TilesTransparency.PARTIAL then
		result = true
	else
		result = tileTransparency ~= thisTransparency
	end
	return result
end

-- Creates block vertices and adds them to the model
local function createBlockVertices(vertices, model)
	local totalVertices = #vertices
	local modelSize = #model
	for i = 1, totalVertices do
		model[modelSize + i] = vertices[i]
	end
end

-- Adds a face to the model based on direction and transparency
local function addFaceToModel(model, x, y, z, otx, oty, BlockModelScale, gettype)
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local x_plus_scale = x + BlockModelScale
	local y_plus_scale = y + BlockModelScale
	local z_plus_scale = z + BlockModelScale
	if gettype == "getTop" or gettype == "getBottom" then
		blockVertices = {
			{ x, y, z, tx, ty },
			{ x_plus_scale, y, z, tx2, ty },
			{ x, y, z_plus_scale, tx, ty2 },
			{ x_plus_scale, y, z, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
			{ x, y, z_plus_scale, tx, ty2 },
		}
	elseif gettype == "getPositiveX" then
		blockVertices = {
			{ x, y_plus_scale, z, tx2, ty },
			{ x, y, z, tx2, ty2 },
			{ x, y, z_plus_scale, tx, ty2 },
			{ x, y_plus_scale, z_plus_scale, tx, ty },
			{ x, y_plus_scale, z, tx2, ty },
			{ x, y, z_plus_scale, tx, ty2 },
		}
	elseif gettype == "getNegativeX" then
		blockVertices = {
			{ x_plus_scale, y, z, tx, ty2 },
			{ x_plus_scale, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
			{ x_plus_scale, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y_plus_scale, z_plus_scale, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
		}
	elseif gettype == "getPositiveZ" then
		blockVertices = {
			{ x, y, z, tx, ty2 },
			{ x, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y, z, tx2, ty2 },
			{ x, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y_plus_scale, z, tx2, ty },
			{ x_plus_scale, y, z, tx2, ty2 },
		}
	elseif gettype == "getNegativeZ" then
		blockVertices = {
			{ x, y_plus_scale, z_plus_scale, tx2, ty },
			{ x, y, z_plus_scale, tx2, ty2 },
			{ x_plus_scale, y, z_plus_scale, tx, ty2 },
			{ x_plus_scale, y_plus_scale, z_plus_scale, tx, ty },
			{ x, y_plus_scale, z_plus_scale, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx, ty2 },
		}
	else
		ThreadLogChannel:push({ LuaCraftLoggingLevel.ERROR, "Invalid gettype: " .. gettype })
	end
	createBlockVertices(blockVertices, model)
end

-- Adds a face to the model based on direction and transparency
local function addFace(gettype, direction, y_offset, light_offset, thisLight, model, thisTransparency, scale, x, y, z)
	if CanDrawFace(direction, thisTransparency) then
		local textureIndex = math.min(2 + y_offset, #TileTextures(direction))
		local texture = (gettype == "getTop" or gettype == "getBottom") and TileTextures(direction)[textureIndex]
			or TileTextures(direction)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - light_offset, 0))
		addFaceToModel(model, x, y + y_offset * scale, z, otx, oty, scale, gettype)
	end
end

-- Draws faces of a block model
local function DrawFaces(model, thisTransparency, thisLight, BlockModelScale, x, y, z)
	addFace("getTop", getTop, 0, 0, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getBottom", getBottom, 1, 3, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveX", getPositiveX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeX", getNegativeX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveZ", getPositiveZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeZ", getNegativeZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
end

-- Checks if the block at the specified coordinates is valid
local function checkBlockValidity(chunk, i, j, k)
	--	if not chunk then
	--		return false
	--	end
	local this = chunk.parent:getVoxel(i, j, k)
	local value = GetValueFromTilesById(this)
	if value then
		local blockstringname = value.blockstringname
		if Tiles[blockstringname].BlockOrLiquidOrTile == TileMode.None then
			return false
		end
	end
	return true
end

-- Updates adjacent blocks for rendering
local function updateAdjacentBlocks(chunk, i, j, k, x, y, z)
	getTop = chunk.parent:getVoxel(i, j - 1, k)
	getBottom = chunk.parent:getVoxel(i, j + 1, k)
	getPositiveX = chunk.parent:getVoxel(i - 1, j, k)
	getNegativeX = chunk.parent:getVoxel(i + 1, j, k)
	getPositiveZ = chunk.parent:getVoxel(i, j, k - 1)
	getNegativeZ = chunk.parent:getVoxel(i, j, k + 1)
	if i == 1 then
		getPositiveX = getVoxelFromChunk(GetChunk, x - 1, y, z, ChunkSize, j, k)
	elseif i == ChunkSize then
		getNegativeX = getVoxelFromChunk(GetChunk, x + 1, y, z, 1, j, k)
	end
	if k == 1 then
		getPositiveZ = getVoxelFromChunk(GetChunk, x, y, z - 1, i, j, ChunkSize)
	elseif k == ChunkSize then
		getNegativeZ = getVoxelFromChunk(GetChunk, x, y, z + 1, i, j, 1)
	end
	return getBottom, getPositiveX, getNegativeX, getPositiveZ, getNegativeZ
end

-- Renders the block at the specified coordinates
local function BlockRendering(chunk, i, j, k, x, y, z, thisTransparency, thisLight, model, BlockModelScale)
	if chunk == nil then
		-- Ajoutez un message de débogage pour indiquer que le chunk est nul
		print("Chunk est nil. Impossible de rendre le bloc.")
		return
	end

	if not checkBlockValidity(chunk, i, j, k) then
		return
	end
	updateAdjacentBlocks(chunk, i, j, k, x, y, z)
	DrawFaces(model, thisTransparency, thisLight, BlockModelScale, x, y, z)
end
local function ChunkHash(x)
	return x < 0 and 2 * math.abs(x) or 1 + 2 * x
end
local function GetChunk(x, y, z)
	local x = math.floor(x)
	local y = math.floor(y)
	local z = math.floor(z)
	print("x:", x, "y:", y, "z:", z)
	local hashx, hashy = ChunkHash(math.floor(x / ChunkSize) + 1), ChunkHash(math.floor(z / ChunkSize) + 1)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	if not getChunk or y < 1 or y > WorldHeight then
		return nil
	end
	local mx, mz = x % ChunkSize + 1, z % ChunkSize + 1
	return getChunk, mx, y, mz, hashx, hashy
end
local chunkTable = {}

while true do
	local data = BlockModellingChannel:demand()
	if data and data.chunkX and data.chunkZ then
		chunkTable.chunkX = data.chunkX
		chunkTable.chunkZ = data.chunkZ

		print("Demande de chunk à X:", chunkTable.chunkX, "Z:", chunkTable.chunkZ)
		local chunk, i, j, k, x, y, z, thisTransparency, Light, SliceModels, BlockModelScale =
			GetChunk(chunkTable.chunkX, 0, chunkTable.chunkZ) -- chunkY est temporairement fixé à 0
		if chunk then
			BlockRendering(chunk, i, j, k, x, y, z, thisTransparency, Light, SliceModels, BlockModelScale)
		end
	else
		print("data, chunkX ou chunkZ est nil")
	end
end
