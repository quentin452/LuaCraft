local OAK_LOG_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LOG_Block", OAK_LOG_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.OAK_LOG_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.OAK_LOG_Block, LightSources[0])
	end)
end

return stone_block
