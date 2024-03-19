--mouseandkeybindlogic.lua
function GamestateGamePausingMouseAndKeybindLogic(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _GamePlayingPauseMenu.y) / Font25:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_GamePlayingPauseMenu.choice then
			_GamePlayingPauseMenu.selection = choiceClicked
			if choiceClicked == 1 then
				love.mouse.setRelativeMode(true)
				Gamestate = GamestatePlayingGame
			elseif choiceClicked == 2 then
				Gamestate = GamestatePlayingGameSettings
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
				Gamestate = GamestateMainMenu
			end
		end
	end
end

--!draw.lua
function GamestateGamePausingDrawGame()
	if Gamestate == GamestateGamePausing then
		_JPROFILER.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		_JPROFILER.pop("drawGamePlayingPauseMenu")
	end
end
