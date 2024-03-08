local OAK_LEAVE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LEAVE_Block", OAK_LEAVE_Block)
	end)
end

return stone_block
