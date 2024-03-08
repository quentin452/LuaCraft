local SAND_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("SAND_Block", SAND_Block)
	end)
end

return stone_block
