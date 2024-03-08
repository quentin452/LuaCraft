local GLOWSTONE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GLOWSTONE_Block", GLOWSTONE_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.GLOWSTONE_Block, TilesTransparency.NONE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.GLOWSTONE_Block, LightSources[15])
	end)
end

return stone_block
