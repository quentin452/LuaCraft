function ExampleMod_GenerateTree(chunk, x, y, z)
	_JPROFILER.push("GenerateTree")

	local treeBlocks = {}

	local treeHeight = 4 + math.floor(math.random() * 2 + 0.5)
	for tr = 1, treeHeight do
		local gx, gy, gz = Globalize(chunk.x, chunk.z, x, y + tr, z)
		table.insert(treeBlocks, { gx, gy, gz, Tiles.OAK_LOG_Block.id })
	end

	local leafWidth = 2
	for lx = -leafWidth, leafWidth do
		for ly = -leafWidth, leafWidth do
			local chance = 1
			if math.abs(lx) == leafWidth and math.abs(ly) == leafWidth then
				chance = 0.5
			end

			if math.random() < chance then
				local gx, gy, gz = Globalize(chunk.x, chunk.z, x + lx, y + treeHeight - 2, z + ly)
				table.insert(treeBlocks, { gx, gy, gz, Tiles.OAK_LEAVE_Block.id })
			end
			if math.random() < chance then
				local gx, gy, gz = Globalize(chunk.x, chunk.z, x + lx, y + treeHeight - 1, z + ly)
				table.insert(treeBlocks, { gx, gy, gz, Tiles.OAK_LEAVE_Block.id })
			end
		end
	end

	local upperLeafWidth = 1
	for lx = -upperLeafWidth, upperLeafWidth do
		for ly = -upperLeafWidth, upperLeafWidth do
			local chance = 1
			if math.abs(lx) == upperLeafWidth and math.abs(ly) == upperLeafWidth then
				chance = 0.5
			end

			if math.random() < chance then
				local gx, gy, gz = Globalize(chunk.x, chunk.z, x + lx, y + treeHeight, z + ly)
				table.insert(treeBlocks, { gx, gy, gz, Tiles.OAK_LEAVE_Block.id })
			end
			if chance == 1 then
				local gx, gy, gz = Globalize(chunk.x, chunk.z, x + lx, y + treeHeight + 1, z + ly)
				table.insert(treeBlocks, { gx, gy, gz, Tiles.OAK_LEAVE_Block.id })
			end
		end
	end

	for _, block in ipairs(treeBlocks) do
		NewChunkRequest(block[1], block[2], block[3], block[4])
	end

	_JPROFILER.pop("GenerateTree")
end
