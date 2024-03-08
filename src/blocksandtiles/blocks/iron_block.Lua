local IRON_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("IRON_Block", IRON_Block)
	end)
end

return stone_block
