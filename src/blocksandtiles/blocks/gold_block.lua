local goldTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "gold.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GOLD_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			goldTexture,
			nil,
			nil
		)
	end)
end

return stone_block
