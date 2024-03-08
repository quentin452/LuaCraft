STONE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STONE_Block", STONE_Block)
	end)
end

return stone_block
