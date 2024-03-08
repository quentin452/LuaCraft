local GLOWSTONE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GLOWSTONE_Block", GLOWSTONE_Block)
	end)
end

return stone_block
