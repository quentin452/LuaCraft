
function TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
	local this = self.parent:getVoxel(i, j, k)
	if TileModel(this) == 1 then
		local otx, oty = NumberToCoord(TileTextures(this)[1], 16, 16)
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
			table.insert(vertices, { x + v[1], y + v[2], z + v[3], v[4], v[5] })
		end

		for _, v in ipairs(vertices) do
			model[#model + 1] = v
		end
	end
end