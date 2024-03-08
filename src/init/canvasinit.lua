local mult = 1
TileCanvas = {}
--TODO DON4T USE CANVAS FOR GAME TILE
function InitializeGameTileCanvas()
	-- create lighting value textures on LightingTexture canvas
	LightValues = 16
	local lightingWidth = finalAtlasSize * LightValues
	LightingTexture = lovegraphics.newCanvas(lightingWidth, finalAtlasSize)
	lovegraphics.setCanvas(LightingTexture)
	lovegraphics.clear(1, 1, 1, 0)
	for i = LightValues, 1, -1 do
		local xx = (i - 1) * finalAtlasSize
		lovegraphics.setColor(mult, mult, mult)
		lovegraphics.draw(atlasImage, xx, 0)
		mult = mult * 0.8
	end
	lovegraphics.setColor(1, 1, 1)
	lovegraphics.setCanvas()
end
