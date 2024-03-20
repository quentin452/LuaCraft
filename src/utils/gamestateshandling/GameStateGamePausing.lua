GamestateGamePausing2 = GameStateBase:new()

function GamestateGamePausing2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / PlayingGamePauseMenu:getWidth()
	local scaleY = h / PlayingGamePauseMenu:getHeight()

	Lovegraphics.draw(PlayingGamePauseMenu, 0, 0, 0, scaleX, scaleY)

	local posY = _GamePlayingPauseMenu.y
	local lineHeight = Font25:getHeight("X")

	-- Title Screen
	drawColorString(_GamePlayingPauseMenu.title, _GamePlayingPauseMenu.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	for n = 1, #_GamePlayingPauseMenu.choice do
		if _GamePlayingPauseMenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		drawColorString(marque .. "" .. _GamePlayingPauseMenu.choice[n], _GamePlayingPauseMenu.x, posY)
		posY = posY + lineHeight
	end
end

function GamestateGamePausing2:mousepressed(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _GamePlayingPauseMenu.y) / Font25:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_GamePlayingPauseMenu.choice then
			_GamePlayingPauseMenu.selection = choiceClicked
			if choiceClicked == 1 then
				love.mouse.setRelativeMode(true)
				SetPlayingGameStatePlayingGame2()
			elseif choiceClicked == 2 then
				SetPlayingGamestatePlayingGameSettings2()
			elseif choiceClicked == 3 then
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
				SetPlayingGamestateMainMenu2()
			end
		end
	end
end
function GamestateGamePausing2:keypressed(k)
	_JPROFILER.push("keysinitGamePlayingPauseMenu")
	if type(_GamePlayingPauseMenu.choice) == "table" and _GamePlayingPauseMenu.selection then
		if k == BackWardKey then
			if _GamePlayingPauseMenu.selection < #_GamePlayingPauseMenu.choice then
				_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection + 1
			end
		elseif k == ForWardKey then
			if _GamePlayingPauseMenu.selection > 1 then
				_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection - 1
			end
		elseif k == "return" then
			if _GamePlayingPauseMenu.selection == 1 then
				love.mouse.setRelativeMode(true)
				SetPlayingGameStatePlayingGame2()
			elseif _GamePlayingPauseMenu.selection == 2 then
				SetPlayingGamestatePlayingGameSettings2()
			elseif _GamePlayingPauseMenu.selection == 3 then
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
				SetPlayingGamestateMainMenu2()
			end
		end
	end
	_JPROFILER.pop("keysinitGamePlayingPauseMenu")
end
