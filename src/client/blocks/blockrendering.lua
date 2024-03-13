--TODO create a cache to avoid recreating the same model several times for the same block
local AIR_TRANSPARENCY = 0
local LEAVES_TRANSPARENCY = 1
local adjustmentFactorValuecalculationotxoty = 256 / finalAtlasSize
local adjustmentFactorValuegetTextureCoordinatesAndLight = finalAtlasSize / 256

local function CanDrawFace(get, thisTransparency)
	_JPROFILER.push("CanDrawFace")
	local tget = TileTransparency(get)
	if tget == AIR_TRANSPARENCY then
		_JPROFILER.pop("CanDrawFace")
		return false
	elseif tget == LEAVES_TRANSPARENCY then
		_JPROFILER.pop("CanDrawFace")
		return true
	else
		_JPROFILER.pop("CanDrawFace")
		return tget ~= thisTransparency
	end
end

local function createBlockVertices(vertices, model)
	_JPROFILER.push("createBlockVertices")
	for _, vertex in ipairs(vertices) do
		model[#model + 1] = vertex
	end
	_JPROFILER.pop("createBlockVertices")
end

function calculationotxoty(otx, oty)
	_JPROFILER.push("calculationotxoty")
	local adjustmentFactor = adjustmentFactorValuecalculationotxoty
	local tx = otx * TileWidth / LightValues
	local ty = oty * TileHeight
	local tx2 = (otx + adjustmentFactor) * TileWidth / LightValues
	local ty2 = (oty + adjustmentFactor) * TileHeight
	_JPROFILER.pop("calculationotxoty")
	return tx, ty, tx2, ty2
end
function getTextureCoordinatesAndLight(texture, lightOffset)
	_JPROFILER.push("getTextureCoordinatesAndLight")
	local textureindex = texture
	local adjustmentFactor = adjustmentFactorValuegetTextureCoordinatesAndLight
	local otx = ((textureindex / adjustmentFactor) % LightValues + 16 * lightOffset)
	local oty = math.floor(textureindex / (adjustmentFactor * LightValues))
	_JPROFILER.pop("getTextureCoordinatesAndLight")
	return otx, oty
end
local function addFaceToModel(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModel")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local vertices = {
		{ x, y, z, tx, ty },
		{ x + scale, y, z, tx2, ty },
		{ x, y, z + scale, tx, ty2 },
		{ x + scale, y, z, tx2, ty },
		{ x + scale, y, z + scale, tx2, ty2 },
		{ x, y, z + scale, tx, ty2 },
	}
	createBlockVertices(vertices, model)
	_JPROFILER.pop("addFaceToModel")
end

local function addFaceToModelPositiveX(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelPositiveX")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local vertices = {
		{ x, y + scale, z, tx2, ty },
		{ x, y, z, tx2, ty2 },
		{ x, y, z + scale, tx, ty2 },
		{ x, y + scale, z + scale, tx, ty },
		{ x, y + scale, z, tx2, ty },
		{ x, y, z + scale, tx, ty2 },
	}
	createBlockVertices(vertices, model)
	_JPROFILER.pop("addFaceToModelPositiveX")
end

local function addFaceToModelNegativeX(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelNegativeX")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local vertices = {
		{ x + scale, y, z, tx, ty2 },
		{ x + scale, y + scale, z, tx, ty },
		{ x + scale, y, z + scale, tx2, ty2 },
		{ x + scale, y + scale, z, tx, ty },
		{ x + scale, y + scale, z + scale, tx2, ty },
		{ x + scale, y, z + scale, tx2, ty2 },
	}
	createBlockVertices(vertices, model)
	_JPROFILER.pop("addFaceToModelNegativeX")
end

local function addFaceToModelPositiveZ(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelPositiveZ")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local vertices = {
		{ x, y, z, tx, ty2 },
		{ x, y + scale, z, tx, ty },
		{ x + scale, y, z, tx2, ty2 },
		{ x, y + scale, z, tx, ty },
		{ x + scale, y + scale, z, tx2, ty },
		{ x + scale, y, z, tx2, ty2 },
	}
	createBlockVertices(vertices, model)
	_JPROFILER.pop("addFaceToModelPositiveZ")
end

local function addFaceToModelNegativeZ(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelNegativeZ")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	local vertices = {
		{ x, y + scale, z + scale, tx2, ty },
		{ x, y, z + scale, tx2, ty2 },
		{ x + scale, y, z + scale, tx, ty2 },
		{ x + scale, y + scale, z + scale, tx, ty },
		{ x, y + scale, z + scale, tx2, ty },
		{ x + scale, y, z + scale, tx, ty2 },
	}
	createBlockVertices(vertices, model)
	_JPROFILER.pop("addFaceToModelNegativeZ")
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

local function DrawFaces(getTop,getBottom,getPositiveX,getNegativeX,getPositiveZ,getNegativeZ,model,thisTransparency,thisLight,scale,x,y,z)
	_JPROFILER.push("DrawFaces_blockrendering")
	if CanDrawFace(getTop, thisTransparency) then
		local textureIndex = math.min(2, #TileTextures(getTop))
		local texture = TileTextures(getTop)[textureIndex]
		local otx, oty = getTextureCoordinatesAndLight(texture, thisLight)
		addFaceToModel(model, x, y, z, otx, oty, scale)
	end
	if CanDrawFace(getBottom, thisTransparency) then
		local textureIndex = math.min(3, #TileTextures(getBottom))
		local texture = TileTextures(getBottom)[textureIndex]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 3, 0))
		addFaceToModel(model, x, y + scale, z, otx, oty, scale)
	end
	if CanDrawFace(getPositiveX, thisTransparency) then
		local texture = TileTextures(getPositiveX)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 2, 0))
		addFaceToModelPositiveX(model, x, y, z, otx, oty, scale)
	end
	if CanDrawFace(getNegativeX, thisTransparency) then
		local texture = TileTextures(getNegativeX)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 2, 0))
		addFaceToModelNegativeX(model, x, y, z, otx, oty, scale)
	end
	if CanDrawFace(getPositiveZ, thisTransparency) then
		local texture = TileTextures(getPositiveZ)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 1, 0))
		addFaceToModelPositiveZ(model, x, y, z, otx, oty, scale)
	end
	if CanDrawFace(getNegativeZ, thisTransparency) then
		local texture = TileTextures(getNegativeZ)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 1, 0))
		addFaceToModelNegativeZ(model, x, y, z, otx, oty, scale)
	end
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
    local getTop = self.parent:getVoxel(i, j - 1, k)
    local getBottom = self.parent:getVoxel(i, j + 1, k)
    local getPositiveX = self.parent:getVoxel(i - 1, j, k)
    local getNegativeX = self.parent:getVoxel(i + 1, j, k)
    local getPositiveZ = self.parent:getVoxel(i, j, k - 1)
    local getNegativeZ = self.parent:getVoxel(i, j, k + 1)

    if i == 1 then
        getPositiveX = getVoxelFromChunk(GetChunk, x - 1, y, z, ChunkSize, j, k)
    end

    if i == ChunkSize then
        getNegativeX = getVoxelFromChunk(GetChunk, x + 1, y, z, 1, j, k)
    end

    if k == 1 then
        getPositiveZ = getVoxelFromChunk(GetChunk, x, y, z - 1, i, j, ChunkSize)
    end

    if k == ChunkSize then
        getNegativeZ = getVoxelFromChunk(GetChunk, x, y, z + 1, i, j, 1)
    end
	_JPROFILER.pop("updateAdjacentBlocks_blockrendering")
    return getTop, getBottom, getPositiveX, getNegativeX, getPositiveZ, getNegativeZ
end

function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
    _JPROFILER.push("BlockRendering")
    if not checkBlockValidity(self, i, j, k) then
        _JPROFILER.pop("BlockRendering")
        return
    end
    local getTop, getBottom, getPositiveX, getNegativeX, getPositiveZ, getNegativeZ = updateAdjacentBlocks(self, i, j, k, x, y, z)
	DrawFaces(getTop,getBottom,getPositiveX,getNegativeX,getPositiveZ,getNegativeZ,model,thisTransparency,thisLight,scale,x,y,z)
    _JPROFILER.pop("BlockRendering")
end
