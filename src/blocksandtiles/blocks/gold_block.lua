local GOLD_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GOLD_Block", GOLD_Block)
	end)
end

return stone_block
