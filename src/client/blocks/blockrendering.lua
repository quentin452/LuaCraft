local AIR_TRANSPARENCY = 0
local LEAVES_TRANSPARENCY = 1

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

 function calculationotxoty(otx, oty)
	_JPROFILER.push("calculationotxoty")
	local adjustmentFactor = 256 / finalAtlasSize
	local tx = otx * TileWidth / LightValues
	local ty = oty * TileHeight
	local tx2 = (otx + adjustmentFactor) * TileWidth / LightValues
	local ty2 = (oty + adjustmentFactor) * TileHeight
	_JPROFILER.pop("calculationotxoty")
	-- LuaCraftPrintLoggingNormal("tx: " .. tx .. ", ty: " .. ty .. ", tx2: " .. tx2 .. ", ty2: " .. ty2)
	return tx, ty, tx2, ty2
end

function getTextureCoordinatesAndLight(texture, lightOffset)
	_JPROFILER.push("getTextureCoordinatesAndLight")
	local textureindex = texture
	local adjustmentFactor = finalAtlasSize / 256
	local otx = ((textureindex / adjustmentFactor) % LightValues + 16 * lightOffset)
	local oty = math.floor(textureindex / (adjustmentFactor * LightValues))
	_JPROFILER.pop("getTextureCoordinatesAndLight")
	-- LuaCraftPrintLoggingNormal("Texture Index: " .. textureindex .. ", otx: " .. otx .. ", oty: " .. oty)
	return otx, oty
end

local function addFaceToModel(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModel")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	model[#model + 1] = { x, y, z, tx, ty }
	model[#model + 1] = { x + scale, y, z, tx2, ty }
	model[#model + 1] = { x, y, z + scale, tx, ty2 }
	model[#model + 1] = { x + scale, y, z, tx2, ty }
	model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
	model[#model + 1] = { x, y, z + scale, tx, ty2 }
	_JPROFILER.pop("addFaceToModel")
end

local function addFaceToModelPositiveX(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelPositiveX")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	model[#model + 1] = { x, y + scale, z, tx2, ty }
	model[#model + 1] = { x, y, z, tx2, ty2 }
	model[#model + 1] = { x, y, z + scale, tx, ty2 }
	model[#model + 1] = { x, y + scale, z + scale, tx, ty }
	model[#model + 1] = { x, y + scale, z, tx2, ty }
	model[#model + 1] = { x, y, z + scale, tx, ty2 }
	_JPROFILER.pop("addFaceToModelPositiveX")
end

local function addFaceToModelNegativeX(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelNegativeX")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	model[#model + 1] = { x + scale, y, z, tx, ty2 }
	model[#model + 1] = { x + scale, y + scale, z, tx, ty }
	model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
	model[#model + 1] = { x + scale, y + scale, z, tx, ty }
	model[#model + 1] = { x + scale, y + scale, z + scale, tx2, ty }
	model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
	_JPROFILER.pop("addFaceToModelNegativeX")
end

local function addFaceToModelPositiveZ(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelPositiveZ")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	model[#model + 1] = { x, y, z, tx, ty2 }
	model[#model + 1] = { x, y + scale, z, tx, ty }
	model[#model + 1] = { x + scale, y, z, tx2, ty2 }
	model[#model + 1] = { x, y + scale, z, tx, ty }
	model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
	model[#model + 1] = { x + scale, y, z, tx2, ty2 }
	_JPROFILER.pop("addFaceToModelPositiveZ")
end

local function addFaceToModelNegativeZ(model, x, y, z, otx, oty, scale)
	_JPROFILER.push("addFaceToModelNegativeZ")
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)
	model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
	model[#model + 1] = { x, y, z + scale, tx2, ty2 }
	model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
	model[#model + 1] = { x + scale, y + scale, z + scale, tx, ty }
	model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
	model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
	_JPROFILER.pop("addFaceToModelNegativeZ")
end

function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
	_JPROFILER.push("BlockRendering")
	-- top and bottom
	local getTop = self.parent:getVoxel(i, j - 1, k)
	local getBottom = self.parent:getVoxel(i, j + 1, k)
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
	-- positive x
	local getPositiveX = self.parent:getVoxel(i - 1, j, k)
	if i == 1 then
		local chunkGet = GetChunk(x - 1, y, z)
		if chunkGet ~= nil then
			getPositiveX = chunkGet:getVoxel(ChunkSize, j, k)
		end
	end
	if CanDrawFace(getPositiveX, thisTransparency) then
		local texture = TileTextures(getPositiveX)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 2, 0))
		addFaceToModelPositiveX(model, x, y, z, otx, oty, scale)
	end
	-- negative x
	local getNegativeX = self.parent:getVoxel(i + 1, j, k)
	if i == ChunkSize then
		local chunkGet = GetChunk(x + 1, y, z)
		if chunkGet ~= nil then
			getNegativeX = chunkGet:getVoxel(1, j, k)
		end
	end
	if CanDrawFace(getNegativeX, thisTransparency) then
		local texture = TileTextures(getNegativeX)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 2, 0))
		addFaceToModelNegativeX(model, x, y, z, otx, oty, scale)
	end
	-- positive z
	local getPositiveZ = self.parent:getVoxel(i, j, k - 1)
	if k == 1 then
		local chunkGet = GetChunk(x, y, z - 1)
		if chunkGet ~= nil then
			getPositiveZ = chunkGet:getVoxel(i, j, ChunkSize)
		end
	end
	if CanDrawFace(getPositiveZ, thisTransparency) then
		local texture = TileTextures(getPositiveZ)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 1, 0))
		addFaceToModelPositiveZ(model, x, y, z, otx, oty, scale)
	end
	-- negative z
	local getNegativeZ = self.parent:getVoxel(i, j, k + 1)
	if k == ChunkSize then
		local chunkGet = GetChunk(x, y, z + 1)
		if chunkGet ~= nil then
			getNegativeZ = chunkGet:getVoxel(i, j, 1)
		end
	end
	if CanDrawFace(getNegativeZ, thisTransparency) then
		local texture = TileTextures(getNegativeZ)[1]
		local otx, oty = getTextureCoordinatesAndLight(texture, math.max(thisLight - 1, 0))
		addFaceToModelNegativeZ(model, x, y, z, otx, oty, scale)
	end
	_JPROFILER.pop("BlockRendering")
end
