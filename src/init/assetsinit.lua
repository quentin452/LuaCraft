function InitializeAssets()
	DefaultTexture = love.graphics.newImage("resources/assets/texture.png")
	if DefaultTexture == nil then
		error("Erreur lors du chargement de la texture.")
	end
	TileTexture = love.graphics.newImage("resources/assets/terrain.png")
	GuiSprites = love.graphics.newImage("resources/assets/gui.png")
end
