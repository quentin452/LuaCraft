local SPONGE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("SPONGE_Block", SPONGE_Block)
	end)
end

return stone_block
