local OAK_SAPPLING_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_SAPPLING_Block", OAK_SAPPLING_Block)
	end)
end

return stone_block
