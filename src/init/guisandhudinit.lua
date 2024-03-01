function InitializeGuisAndHud()
	GuiHotbarQuad = love.graphics.newQuad(0, 0, 182, 22, GuiSprites:getDimensions())
	GuiHotbarSelectQuad = love.graphics.newQuad(0, 22, 24, 22 + 24, GuiSprites:getDimensions())
	GuiCrosshair = love.graphics.newQuad(256 - 16, 0, 256, 16, GuiSprites:getDimensions())
end