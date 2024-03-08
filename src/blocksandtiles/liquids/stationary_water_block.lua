local STATIONARY_WATER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STATIONARY_WATER_Block", STATIONARY_WATER_Block)
	end)
end

return stone_block
