local stoneTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "stone.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"STONE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			stoneTexture,
			nil,
			nil
		)
	end)
end

return stone_block
