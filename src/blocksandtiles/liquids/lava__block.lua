local LAVA_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("LAVA_Block", LAVA_Block)
	end)
end

return stone_block
