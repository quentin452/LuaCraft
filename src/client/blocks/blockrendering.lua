--TODO create a cache to avoid recreating the same model several times for the same block
local AIR_TRANSPARENCY = 0
local LEAVES_TRANSPARENCY = 1
local adjustmentFactorValuecalculationotxoty = 256 / finalAtlasSize
local adjustmentFactorValuegetTextureCoordinatesAndLight = finalAtlasSize / 256
local getTop
local getBottom
local getPositiveX
local getNegativeX
local getPositiveZ
local getNegativeZ
local blockVertices = {}

local function CanDrawFace(get, thisTransparency)
	_JPROFILER.push("CanDrawFace")
	local tileTransparency = TileTransparency(get)
	local result = true
	if tileTransparency == AIR_TRANSPARENCY then
		result = false
	elseif tileTransparency == LEAVES_TRANSPARENCY then
		result = true
	else
		result = tileTransparency ~= thisTransparency
	end
	_JPROFILER.pop("CanDrawFace")
	return result
end

function calculationotxoty(otx, oty)
	_JPROFILER.push("calculationotxoty")
	local tx = otx * TileWidth / LightValues
	local ty = oty * TileHeight
	local tx2 = (otx + adjustmentFactorValuecalculationotxoty) * TileWidth / LightValues
	local ty2 = (oty + adjustmentFactorValuecalculationotxoty) * TileHeight
	_JPROFILER.pop("calculationotxoty")
	return tx, ty, tx2, ty2
end

function getTextureCoordinatesAndLight(texture, lightOffset)
	_JPROFILER.push("getTextureCoordinatesAndLight")
	local textureindex = texture
	local otx = ((textureindex / adjustmentFactorValuegetTextureCoordinatesAndLight) % LightValues + 16 * lightOffset)
	local oty = math.floor(textureindex / (adjustmentFactorValuegetTextureCoordinatesAndLight * LightValues))
	_JPROFILER.pop("getTextureCoordinatesAndLight")
	return otx, oty
end

local function getVoxelFromChunk(chunkGetter, x, y, z, i, j, k)
	_JPROFILER.push("getVoxelFromChunk_blockrendering")
	local chunkGet = chunkGetter(x, y, z)
	if chunkGet ~= nil then
		_JPROFILER.pop("getVoxelFromChunk_blockrendering")
		return chunkGet:getVoxel(i, j, k)
	end
	_JPROFILER.pop("getVoxelFromChunk_blockrendering")
	return nil
end

local function createBlockVertices(vertices, model)
	_JPROFILER.push("createBlockVertices")
	local totalVertices = #vertices
	local modelSize = #model
	for i = 1, totalVertices do
		model[modelSize + i] = vertices[i]
	end
	_JPROFILER.pop("createBlockVertices")
end

local function addFaceToModel(model, x, y, z, otx, oty, scale, gettype)
	_JPROFILER.push("addFaceToModel")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local x_plus_scale = x + scale
	local y_plus_scale = y + scale
	local z_plus_scale = z + scale
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
		LuaCraftErrorLogging("Invalid gettype: " .. gettype)
	end

	createBlockVertices(blockVertices, model)
	_JPROFILER.pop("addFaceToModel")
end

local function addFace(gettype, direction, y_offset, light_offset, thisLight, model, thisTransparency, scale, x, y, z)
	_JPROFILER.push("addFace_blockrendering")
	if CanDrawFace(direction, thisTransparency) then
		local textureIndex = math.min(2 + y_offset, #TileTextures(direction))
		local texture = (gettype == "getTop" or gettype == "getBottom") and TileTextures(direction)[textureIndex]
			or TileTextures(direction)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - light_offset, 0))
		addFaceToModel(model, x, y + y_offset * scale, z, otx, oty, scale, gettype)
	end
	_JPROFILER.pop("addFace_blockrendering")
end

local function DrawFaces(model, thisTransparency, thisLight, scale, x, y, z)
	_JPROFILER.push("DrawFaces_blockrendering")
	addFace("getTop", getTop, 0, 0, thisLight, model, thisTransparency, scale, x, y, z)
	addFace("getBottom", getBottom, 1, 3, thisLight, model, thisTransparency, scale, x, y, z)
	addFace("getPositiveX", getPositiveX, 0, 2, thisLight, model, thisTransparency, scale, x, y, z)
	addFace("getNegativeX", getNegativeX, 0, 2, thisLight, model, thisTransparency, scale, x, y, z)
	addFace("getPositiveZ", getPositiveZ, 0, 1, thisLight, model, thisTransparency, scale, x, y, z)
	addFace("getNegativeZ", getNegativeZ, 0, 1, thisLight, model, thisTransparency, scale, x, y, z)
	_JPROFILER.pop("DrawFaces_blockrendering")
end

local function checkBlockValidity(self, i, j, k)
	_JPROFILER.push("checkBlockValidity_blockrendering")
	local this = self.parent:getVoxel(i, j, k)
	local value = TilesById[this]
	if value then
		local blockstringname = value.blockstringname
		if Tiles[blockstringname].BlockOrLiquidOrTile == TileMode.None then
			_JPROFILER.pop("checkBlockValidity_blockrendering")
			return false
		end
	end
	_JPROFILER.pop("checkBlockValidity_blockrendering")
	return true
end

local function updateAdjacentBlocks(self, i, j, k, x, y, z)
	_JPROFILER.push("updateAdjacentBlocks_blockrendering")
	getTop = self.parent:getVoxel(i, j - 1, k)
	getBottom = self.parent:getVoxel(i, j + 1, k)
	getPositiveX = self.parent:getVoxel(i - 1, j, k)
	getNegativeX = self.parent:getVoxel(i + 1, j, k)
	getPositiveZ = self.parent:getVoxel(i, j, k - 1)
	getNegativeZ = self.parent:getVoxel(i, j, k + 1)
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
	_JPROFILER.pop("updateAdjacentBlocks_blockrendering")
	return getBottom, getPositiveX, getNegativeX, getPositiveZ, getNegativeZ
end

function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
	_JPROFILER.push("BlockRendering")
	if not checkBlockValidity(self, i, j, k) then
		_JPROFILER.pop("BlockRendering")
		return
	end
	updateAdjacentBlocks(self, i, j, k, x, y, z)
	DrawFaces(model, thisTransparency, thisLight, scale, x, y, z)
	_JPROFILER.pop("BlockRendering")
end
