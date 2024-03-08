local GLASS_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GLASS_Block", GLASS_Block)
	end)
end

return stone_block
