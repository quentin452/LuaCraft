function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
	-- top
	local get = self.parent:getVoxel(i, j - 1, k)
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[math.min(2, #TileTextures(get))], 16, 16)
		otx = otx + 16 * thisLight
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y, z, tx, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y, z, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
	end

	-- bottom
	local get = self.parent:getVoxel(i, j + 1, k)
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[math.min(3, #TileTextures(get))], 16, 16)
		otx = otx + 16 * math.max(thisLight - 3, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty2 }
	end

	-- positive x
	local get = self.parent:getVoxel(i - 1, j, k)
	if i == 1 then
		local chunkGet = GetChunk(x - 1, y, z)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(ChunkSize, j, k)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
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
	local get = self.parent:getVoxel(i + 1, j, k)
	if i == ChunkSize then
		local chunkGet = GetChunk(x + 1, y, z)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(1, j, k)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
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
	local get = self.parent:getVoxel(i, j, k - 1)
	if k == 1 then
		local chunkGet = GetChunk(x, y, z - 1)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(i, j, ChunkSize)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
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
	local get = self.parent:getVoxel(i, j, k + 1)
	if k == ChunkSize then
		local chunkGet = GetChunk(x, y, z + 1)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(i, j, 1)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
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
