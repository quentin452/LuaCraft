local COAL_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("COAL_Block", COAL_Block)
	end)
end

return stone_block
