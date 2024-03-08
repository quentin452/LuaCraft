local OAK_LEAVE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LEAVE_Block", OAK_LEAVE_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.OAK_LEAVE_Block, TilesTransparency.PARTIAL)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.OAK_LEAVE_Block, LightSources[0])
	end)
end

return stone_block
