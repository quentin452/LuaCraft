local _GamePlayingPauseMenu = CreateLuaCraftMenu(0, 0, "Pause", {
	"UnPause",
	"Settings",
	"Exit to main menu",
})

GamestateGamePausing2 = GameStateBase:new()
function GamestateGamePausing2:resetMenuSelection()
	_GamePlayingPauseMenu.selection = 1
end
function GamestateGamePausing2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / PlayingGamePauseMenu:getWidth()
	local scaleY = h / PlayingGamePauseMenu:getHeight()

	Lovegraphics.draw(PlayingGamePauseMenu, 0, 0, 0, scaleX, scaleY)

	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = getSelectedFont():getHeight("X")
	drawColorString(_GamePlayingPauseMenu.title, posX, posY)
	posY = posY + lineHeight
	local marque = ""
	for n = 1, #_GamePlayingPauseMenu.choice do
		if _GamePlayingPauseMenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		drawColorString(marque .. "" .. _GamePlayingPauseMenu.choice[n], posX, posY)
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
		love.mouse.setRelativeMode(true)
		WorldSuccessfullyLoaded = true
		SetCurrentGameState(GameStatePlayingGame2)
	elseif action == 2 then
		SetCurrentGameState(GamestatePlayingGameSettings2)
	elseif action == 3 then
		ClearChunksAndGoToMainMenu()
	end
end
function GamestateGamePausing2:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = getSelectedFont():getHeight("X")
		local menuWidth = 0
		for _, choice in ipairs(_GamePlayingPauseMenu.choice) do
			local choiceWidth = getSelectedFont():getWidth(choice)
			if choiceWidth > menuWidth then
				menuWidth = choiceWidth
			end
		end
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if choiceClicked >= 1 and choiceClicked <= #_GamePlayingPauseMenu.choice and x >= minX and x <= maxX then
			_GamePlayingPauseMenu.selection = choiceClicked
			PerformMenuAction(choiceClicked)
		end
	end
end
function GamestateGamePausing2:keypressed(k)
	_JPROFILER.push("keysinitGamePlayingPauseMenu")
	if k == BackWardKey then
		if _GamePlayingPauseMenu.selection < #_GamePlayingPauseMenu.choice then
			_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection + 1
		end
	elseif k == ForWardKey then
		if _GamePlayingPauseMenu.selection > 1 then
			_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection - 1
		end
	elseif k == "return" then
		PerformMenuAction(_GamePlayingPauseMenu.selection)
	end
	_JPROFILER.pop("keysinitGamePlayingPauseMenu")
end

function GamestateGamePausing2:setFont()
	return Font25
end
