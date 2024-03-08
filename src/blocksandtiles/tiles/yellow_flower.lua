local YELLO_FLOWER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("YELLO_FLOWER_Block", YELLO_FLOWER_Block)
	end)
end

return stone_block
