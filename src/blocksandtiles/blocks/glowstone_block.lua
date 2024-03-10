local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GLOWSTONE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.NONE,
			LightSources[15]
		)
	end)
end

return stone_block
