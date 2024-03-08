local GLASS_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GLASS_Block", GLASS_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.GLASS_Block, TilesTransparency.NONE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.GLASS_Block, LightSources[0])
	end)
end

return stone_block
