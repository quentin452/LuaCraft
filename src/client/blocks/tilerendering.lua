TileModelCaching = {}

function TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
	_JPROFILER.push("TileRendering")
	local this = self.parent:getVoxel(i, j, k)

	if TileModel(this) == 1 then
		local tileModelData = TileModelCaching[this]
		if not tileModelData then
			tileModelData = createTileModel(this, thisLight, scale)
			TileModelCaching[this] = tileModelData
		end

		for _, v in ipairs(tileModelData) do
			model[#model + 1] = { x + v[1], y + v[2], z + v[3], v[4], v[5] }
		end

		for _, v in ipairs(tileModelData) do
			local originX = v[1] - 0.5
			local originZ = v[3] - 0.5

			local rotatedX = originX * math.cos(math.pi / 2) - originZ * math.sin(math.pi / 2)
			local rotatedZ = originX * math.sin(math.pi / 2) + originZ * math.cos(math.pi / 2)

			rotatedX = rotatedX + 0.5
			rotatedZ = rotatedZ + 0.5

			model[#model + 1] = { x + rotatedX, y + v[2], z + rotatedZ, v[4], v[5] }
		end
	end

	_JPROFILER.pop("TileRendering")
end

function createTileModel(tileID, thisLight, scale)
	_JPROFILER.push("createTileModel")
	local texture = TileTextures(tileID)[1]
	local otx, oty = getTextureCoordinatesAndLight(texture, thisLight)
	local tx, ty, tx2, ty2 = calculationotxoty(otx, oty)

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
