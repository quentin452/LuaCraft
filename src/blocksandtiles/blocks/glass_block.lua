local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GLASS_Block", TileMode.BlockMode, CollideMode.YesCanCollide, TilesTransparency.NONE, LightSources[0])
	end)
end

return stone_block
