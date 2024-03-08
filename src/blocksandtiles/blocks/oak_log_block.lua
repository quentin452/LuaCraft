local OAK_LOG_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LOG_Block", OAK_LOG_Block)
	end)
end

return stone_block
