local OAK_PLANK_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_PLANK_Block", OAK_PLANK_Block)
	end)
end

return stone_block
