local mult = 1
--TODO DON4T USE CANVAS FOR GAME TILE
function InitializeGameTileCanvas()
	-- create lighting value textures on LightingTexture canvas
	local lightingWidth = FinalAtlasSize * LightValues
	LightingTexture = Lovegraphics.newCanvas(lightingWidth, FinalAtlasSize)
	Lovegraphics.setCanvas(LightingTexture)
	Lovegraphics.clear(1, 1, 1, 0)
	for i = LightValues, 1, -1 do
		local xx = (i - 1) * FinalAtlasSize
		Lovegraphics.setColor(mult, mult, mult)
		Lovegraphics.draw(atlasImage, xx, 0)
		mult = mult * 0.8
	end
	Lovegraphics.setColor(1, 1, 1)
	Lovegraphics.setCanvas()
end
