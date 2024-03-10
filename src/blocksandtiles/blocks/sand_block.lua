local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("SAND_Block", TileMode.BlockMode, CollideMode.YesCanCollide, TilesTransparency.OPAQUE, LightSources[0])
	end)
end

return stone_block
