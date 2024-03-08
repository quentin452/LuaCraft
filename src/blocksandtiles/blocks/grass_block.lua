local GRASS_Block = nil

local grass_block = {}

function grass_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GRASS_Block", GRASS_Block)
	end)
end

return grass_block
