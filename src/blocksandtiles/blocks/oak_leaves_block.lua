local oak_leavesTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "oak_leaves.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"OAK_LEAVE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.PARTIAL,
			LightSources[0],
			oak_leavesTexture,
			nil,
			nil
		)
	end)
end

return stone_block
