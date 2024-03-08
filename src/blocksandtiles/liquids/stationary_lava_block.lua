local STATIONARY_LAVA_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STATIONARY_LAVA_Block", STATIONARY_LAVA_Block)
	end)
end

return stone_block
