local AIR_TRANSPARENCY = 0
local LEAVES_TRANSPARENCY = 1

local function CanDrawFace(get, thisTransparency)
	local tget = TileTransparency(get)

	if tget == AIR_TRANSPARENCY then
		return false
	elseif tget == LEAVES_TRANSPARENCY then
		return true
	else
		return tget ~= thisTransparency
	end
end

local function addFaceToModel(model, x, y, z, otx, oty, thisLight, scale, txModifier, tyModifier)
	local otx2, oty2 = otx + 1, oty + 1
	local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
	local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

	model[#model + 1] = { x, y, z, tx + txModifier, ty + tyModifier }
	model[#model + 1] = { x + scale, y, z, tx2 + txModifier, ty + tyModifier }
	model[#model + 1] = { x, y, z + scale, tx + txModifier, ty2 + tyModifier }
	model[#model + 1] = { x + scale, y, z, tx2 + txModifier, ty + tyModifier }
	model[#model + 1] = { x + scale, y, z + scale, tx2 + txModifier, ty2 + tyModifier }
	model[#model + 1] = { x, y, z + scale, tx + txModifier, ty2 + tyModifier }
end

function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
	-- top and bottom
	local getTop = self.parent:getVoxel(i, j - 1, k)
	local getBottom = self.parent:getVoxel(i, j + 1, k)

	if CanDrawFace(getTop, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(getTop)[math.min(2, #TileTextures(getTop))], 16, 16)
		otx = otx + 16 * thisLight
		addFaceToModel(model, x, y, z, otx, oty, thisLight, scale, 0, 0)
	end

	if CanDrawFace(getBottom, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(getBottom)[math.min(3, #TileTextures(getBottom))], 16, 16)
		otx = otx + 16 * math.max(thisLight - 3, 0)
		addFaceToModel(model, x, y + scale, z, otx, oty, thisLight, scale, 0, 0)
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
		local otx, oty = NumberToCoord(TileTextures(getPositiveX)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 2, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y, z, tx2, ty2 }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty }
		model[#model + 1] = { x, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
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
		local otx, oty = NumberToCoord(TileTextures(getNegativeX)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 2, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x + scale, y, z, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
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
		local otx, oty = NumberToCoord(TileTextures(getPositiveZ)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 1, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y, z, tx, ty2 }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty2 }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty2 }
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
		local otx, oty = NumberToCoord(TileTextures(getNegativeZ)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 1, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
	end
end
