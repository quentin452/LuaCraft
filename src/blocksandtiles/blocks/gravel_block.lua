local GRAVEL_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GRAVEL_Block", GRAVEL_Block)
	end)
end

return stone_block
