--Backgrounds
mainMenuBackground = nil
mainMenuSettingsBackground = nil
gameplayingpausemenu = nil
playinggamesettings = nil
worldCreationBackground = nil
function InitializeAssets()
	DefaultTexture = love.graphics.newImage("resources/assets/texture.png")
	if DefaultTexture == nil then
		error("Erreur lors du chargement de la texture.")
	end
	TileTexture = love.graphics.newImage("resources/assets/terrain.png")
	GuiSprites = love.graphics.newImage("resources/assets/gui.png")
	mainMenuBackground = lovegraphics.newImage("resources/assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = lovegraphics.newImage("resources/assets/backgrounds/Mainmenusettingsbackground.png")
	gameplayingpausemenu = lovegraphics.newImage("resources/assets/backgrounds/gameplayingpausemenu.png")
	playinggamesettings = lovegraphics.newImage("resources/assets/backgrounds/playinggamesettings.png")
	worldCreationBackground = lovegraphics.newImage("resources/assets/backgrounds/WorldCreationBackground.png")

	BlockTest = love.graphics.newImage("resources/assets/textures/blocks/Stone.png")
	ChunkBorders = love.graphics.newImage("resources/assets/textures/debug/chunkborders.png")
end
