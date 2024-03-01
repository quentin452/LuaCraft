local blockModelCache = {}
function TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
	if self.enableBlockAndTilesModels then
		local this = self.parent:getVoxel(i, j, k)
		if TileModel(this) == 1 then
			if not blockModelCache[this] then
				blockModelCache[this] = createTileModel(self, this, thisLight, scale)
			end

			for _, v in ipairs(blockModelCache[this]) do
				model[#model + 1] = { x + v[1], y + v[2], z + v[3], v[4], v[5] }
			end

			--create model dupplicata for flowers/sapplings
			if this == __YELLO_FLOWER_Block or this == __ROSE_FLOWER_Block or this == __OAK_SAPPLING_Block then
				for _, v in ipairs(blockModelCache[this]) do
					local originX = v[1] - 0.5
					local originZ = v[3] - 0.5

					local rotatedX = originX * math.cos(math.pi / 2) - originZ * math.sin(math.pi / 2)
					local rotatedZ = originX * math.sin(math.pi / 2) + originZ * math.cos(math.pi / 2)

					rotatedX = rotatedX + 0.5
					rotatedZ = rotatedZ + 0.5

					model[#model + 1] = { x + rotatedX, y + v[2], z + rotatedZ, v[4], v[5] }
				end
			end
		end
	elseif self.enableBlockAndTilesModels == false then
		--	self.model:setVerts({})
	end
end

function createTileModel(self, tileID, thisLight, scale)
	local otx, oty = NumberToCoord(TileTextures(tileID)[1], 16, 16)
	otx = otx + 16 * thisLight
	local otx2, oty2 = otx + 1, oty + 1
	local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
	local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

	local diagLong = 0.7071 * scale * 0.5 + 0.5
	local diagShort = -0.7071 * scale * 0.5 + 0.5

	local vertices = {}

	for _, v in ipairs({
		{ diagShort, 0, diagShort, tx2, ty2 },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagShort, scale, diagShort, tx2, ty },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagLong, scale, diagLong, tx, ty },
		{ diagShort, scale, diagShort, tx2, ty },
	}) do
		table.insert(vertices, v)
	end

	return vertices
end
