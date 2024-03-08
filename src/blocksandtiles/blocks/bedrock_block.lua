local BEDROCK_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("BEDROCK_Block", BEDROCK_Block)
	end)
end

return stone_block
