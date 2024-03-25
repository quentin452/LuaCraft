-- Shared block vertices
local blockVertices = {}
-- Checks if a face can be drawn based on transparency
local function CanDrawFace(get, thisTransparency)
	_JPROFILER.push("CanDrawFace")
	local startTime = os.clock()
	local tileTransparency = TileTransparency(get)
	local result = true
	if tileTransparency == TilesTransparency.FULL then
		result = false
	elseif tileTransparency == TilesTransparency.PARTIAL then
		result = true
	else
		result = tileTransparency ~= thisTransparency
	end
	local endTime = os.clock()
	BlockModellingTestUnitTimer = BlockModellingTestUnitTimer + 1
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"CanDrawFace Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("CanDrawFace")
	return result
end
-- Creates block vertices and adds them to the model
local function createBlockVertices(vertices, model)
	_JPROFILER.push("createBlockVertices")
	local startTime = os.clock()
	local totalVertices = #vertices
	local modelSize = #model
	for i = 1, totalVertices do
		model[modelSize + i] = vertices[i]
	end
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"createBlockVertices Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("createBlockVertices")
end

-- Adds a face to the model based on direction and transparency
local function addFaceToModel(model, x, y, z, otx, oty, BlockModelScale, gettype)
	_JPROFILER.push("addFaceToModel")
	local startTime = os.clock()
	local tx, ty, tx2, ty2 = Calculationotxoty(otx, oty)
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
		LuaCraftLoggingFunc(LuaCraftLoggingLevel.ERROR, "Invalid gettype: " .. gettype)
	end
	createBlockVertices(blockVertices, model)
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"addFaceToModel Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("addFaceToModel")
end

-- Adds a face to the model based on direction and transparency
local function addFace(gettype, direction, y_offset, light_offset, thisLight, model, thisTransparency, scale, x, y, z)
	_JPROFILER.push("addFace_blockrendering")
	local startTime = os.clock()
	if CanDrawFace(direction, thisTransparency) then
		local textureIndex = math.min(2 + y_offset, #TileTextures(direction))
		local texture = (gettype == "getTop" or gettype == "getBottom") and TileTextures(direction)[textureIndex]
			or TileTextures(direction)[1]
		local otx, oty = GetTextureCoordinatesAndLight(texture, math.max(thisLight - light_offset, 0))
		addFaceToModel(model, x, y + y_offset * scale, z, otx, oty, scale, gettype)
	end
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(LuaCraftLoggingLevel.NORMAL, "addFace Execution Time: " .. tostring(endTime - startTime))
	end
	_JPROFILER.pop("addFace_blockrendering")
end

-- Draws faces of a block model
local function DrawFaces(model, thisTransparency, thisLight, BlockModelScale, x, y, z)
	_JPROFILER.push("DrawFaces_blockrendering")
	local startTime = os.clock()
	addFace("getTop", BlockGetTop, 0, 0, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getBottom", BlockGetBottom, 1, 3, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveX", BlockGetPositiveX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeX", BlockGetNegativeX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveZ", BlockGetPositiveZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeZ", BlockGetNegativeZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(LuaCraftLoggingLevel.NORMAL, "DrawFaces Execution Time: " .. tostring(endTime - startTime))
	end
	_JPROFILER.pop("DrawFaces_blockrendering")
end
-- Checks if the block at the specified coordinates is valid
local function checkBlockValidity(self, i, j, k)
	_JPROFILER.push("checkBlockValidity_blockrendering")
	local startTime = os.clock()
	local this = self.parent:getVoxel(i, j, k)
	local value = GetValueFromTilesById(this)
	if value then
		local blockstringname = value.blockstringname
		if Tiles[blockstringname].BlockOrLiquidOrTile == TileMode.None then
			_JPROFILER.pop("checkBlockValidity_blockrendering")
			return false
		end
	end
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"checkBlockValidity Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("checkBlockValidity_blockrendering")
	return true
end

-- Updates adjacent blocks for rendering
local function updateAdjacentBlocks(self, i, j, k, x, y, z)
	_JPROFILER.push("updateAdjacentBlocks_blockrendering")
	local startTime = os.clock()
	BlockGetTop = self.parent:getVoxel(i, j - 1, k)
	BlockGetBottom = self.parent:getVoxel(i, j + 1, k)
	BlockGetPositiveX = self.parent:getVoxel(i - 1, j, k)
	BlockGetNegativeX = self.parent:getVoxel(i + 1, j, k)
	BlockGetPositiveZ = self.parent:getVoxel(i, j, k - 1)
	BlockGetNegativeZ = self.parent:getVoxel(i, j, k + 1)
	if i == 1 then
		BlockGetPositiveX = getVoxelFromChunk(GetChunk, x - 1, y, z, ChunkSize, j, k)
	elseif i == ChunkSize then
		BlockGetNegativeX = getVoxelFromChunk(GetChunk, x + 1, y, z, 1, j, k)
	end
	if k == 1 then
		BlockGetPositiveZ = getVoxelFromChunk(GetChunk, x, y, z - 1, i, j, ChunkSize)
	elseif k == ChunkSize then
		BlockGetNegativeZ = getVoxelFromChunk(GetChunk, x, y, z + 1, i, j, 1)
	end
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"updateAdjacentBlocks Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("updateAdjacentBlocks_blockrendering")
	return BlockGetTop, BlockGetBottom, BlockGetPositiveX, BlockGetNegativeX, BlockGetPositiveZ, BlockGetNegativeZ
end

function BlockRenderingTestUnit(self, i, j, k, x, y, z, thisTransparency, thisLight, model, BlockModelScale)
	_JPROFILER.push("BlockRendering")
	local startTime = os.clock()
	if not checkBlockValidity(self, i, j, k) then
		_JPROFILER.pop("BlockRendering")
		return
	end
	updateAdjacentBlocks(self, i, j, k, x, y, z)
	DrawFaces(model, thisTransparency, thisLight, BlockModelScale, x, y, z)
	local endTime = os.clock()
	if BlockModellingTestUnitTimer <= 10000 then
		LuaCraftLoggingFunc(
			LuaCraftLoggingLevel.NORMAL,
			"BlockRenderingTestUnit Execution Time: " .. tostring(endTime - startTime)
		)
	end
	_JPROFILER.pop("BlockRendering")
end
