local ROSE_FLOWER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("ROSE_FLOWER_Block", ROSE_FLOWER_Block)
	end)
end

return stone_block
