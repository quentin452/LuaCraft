local coalTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "coal.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"COAL_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			coalTexture,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
