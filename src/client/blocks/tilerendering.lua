local blockModelCache = {}

function TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
	_JPROFILER.push("TileRendering")
	local this = self.parent:getVoxel(i, j, k)

	if TileModel(this) == 1 then
		if not blockModelCache[this] then
			blockModelCache[this] = createTileModel(this, thisLight, scale)
		end

		for _, v in ipairs(blockModelCache[this]) do
			model[#model + 1] = { x + v[1], y + v[2], z + v[3], v[4], v[5] }
		end

		-- create model dupplicata for flowers/sapplings
		if this == Tiles.YELLO_FLOWER_Block or this == Tiles.ROSE_FLOWER_Block or this == Tiles.OAK_SAPPLING_Block then
			for _, v in ipairs(blockModelCache[this]) do
				local originX = v[1] - 0.5
				local originZ = v[3] - 0.5

				local rotatedX = originX * math.cos(mathpi / 2) - originZ * math.sin(mathpi / 2)
				local rotatedZ = originX * math.sin(mathpi / 2) + originZ * math.cos(mathpi / 2)

				rotatedX = rotatedX + 0.5
				rotatedZ = rotatedZ + 0.5

				model[#model + 1] = { x + rotatedX, y + v[2], z + rotatedZ, v[4], v[5] }
			end
		end
	end
	_JPROFILER.pop("TileRendering")
end

function createTileModel(tileID, thisLight, scale)
	_JPROFILER.push("createTileModel")
	local otx, oty = NumberToCoord(TileTextures(tileID)[1], 16, 16)
	otx = otx + 16 * thisLight
	local otx2, oty2 = otx + 1, oty + 1
	local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
	local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

	local diagLong = 0.7071 * scale * 0.5 + 0.5
	local diagShort = -0.7071 * scale * 0.5 + 0.5

	local vertices = {
		{ diagShort, 0, diagShort, tx2, ty2 },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagShort, scale, diagShort, tx2, ty },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagLong, scale, diagLong, tx, ty },
		{ diagShort, scale, diagShort, tx2, ty },
	}
	_JPROFILER.pop("createTileModel")
	return vertices
end
