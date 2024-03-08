local STONE_BRICK_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STONE_BRICK_Block", STONE_BRICK_Block)
	end)
end

return stone_block
