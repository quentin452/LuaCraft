local _GamePlayingPauseMenu = CreateLuaCraftMenu(0, 0, "Pause", {
	"UnPause",
	"Settings",
	"Exit to main menu",
})
local MenuTable = _GamePlayingPauseMenu
GamestateGamePausing2 = GameStateBase:new()
function GamestateGamePausing2:resetMenuSelection()
	MenuTable.selection = 1
end
local marque = ""

function GamestateGamePausing2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / PlayingGamePauseMenu:getWidth()
	local scaleY = h / PlayingGamePauseMenu:getHeight()

	Lovegraphics.draw(PlayingGamePauseMenu, 0, 0, 0, scaleX, scaleY)

	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = GetSelectedFont():getHeight("X")
	DrawColorString(MenuTable.title, posX, posY)
	posY = posY + lineHeight
	for n = 1, #MenuTable.choice do
		if MenuTable.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		DrawColorString(marque .. "" .. MenuTable.choice[n], posX, posY)
		posY = posY + lineHeight
	end
end

local function ClearChunksAndGoToMainMenu()
	--TODO here add chunk saving system before going to MainMenu and during gameplay
	for chunk in pairs(ChunkSet) do
		for _, chunkSlice in ipairs(chunk.slices) do
			chunkSlice.alreadyrendered = false
			chunkSlice.model = nil
		end
	end

	ChunkSet = {}
	ChunkHashTable = {}
	CaveList = {}
	ThePlayer.IsPlayerHasSpawned = false
	GlobalWorldType = StandardTerrain
	SetCurrentGameState(GamestateMainMenu2)
end

local function PerformMenuAction(action)
	if action == 1 then
		WorldSuccessfullyLoaded = true
		SetCurrentGameState(GameStatePlayingGame2)
	elseif action == 2 then
		SetCurrentGameState(GamestatePlayingGameSettings2)
	elseif action == 3 then
		ClearChunksAndGoToMainMenu()
	end
end
function GamestateGamePausing2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
function GamestateGamePausing2:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GamestateGamePausing2:keypressed(k)
	MenuTable.choice, MenuTable.selection =
		SharedSelectionKeyPressedBetweenGameState(k, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GamestateGamePausing2:setFont()
	return Font25
end
