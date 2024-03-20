local bedrockTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "bedrock.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"BEDROCK_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			bedrockTexture,
			Lovegraphics.newImage(bedrockTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
