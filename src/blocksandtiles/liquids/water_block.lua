local WATER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("WATER_Block", WATER_Block)
	end)
end

return stone_block
