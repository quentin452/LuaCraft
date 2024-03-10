local gravelTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "gravel.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GRAVEL_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			gravelTexture,
			nil,
			nil
		)
	end)
end

return stone_block
