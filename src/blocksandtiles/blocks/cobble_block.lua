local COBBLE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("COBBLE_Block", COBBLE_Block)
	end)
end

return stone_block
