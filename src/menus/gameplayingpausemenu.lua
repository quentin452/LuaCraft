_GamePlayingPauseMenu = {}
_GamePlayingPauseMenu.x = 50
_GamePlayingPauseMenu.y = 50
_GamePlayingPauseMenu.title = "Pause"
_GamePlayingPauseMenu.choice = {}
_GamePlayingPauseMenu.choice[1] = "UnPause"
_GamePlayingPauseMenu.choice[2] = "Settings"
_GamePlayingPauseMenu.choice[3] = "Exit to main menu"
_GamePlayingPauseMenu.selection = 1

function drawGamePlayingPauseMenu()
	local w, h = lovegraphics.getDimensions()
	local scaleX = w / playingGamePauseMenu:getWidth()
	local scaleY = h / playingGamePauseMenu:getHeight()

	lovegraphics.draw(playingGamePauseMenu, 0, 0, 0, scaleX, scaleY)

	local posY = _GamePlayingPauseMenu.y
	local lineHeight = font25:getHeight("X")

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

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _GamePlayingPauseMenu.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _GamePlayingPauseMenu.x, posY)
end

function keysinitGamePlayingPauseMenu(k)
	_JPROFILER.push("keysinitGamePlayingPauseMenu")
	if type(_GamePlayingPauseMenu.choice) == "table" and _GamePlayingPauseMenu.selection then
		if k == "s" then
			if _GamePlayingPauseMenu.selection < #_GamePlayingPauseMenu.choice then
				_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection + 1
			end
		elseif k == "z" then
			if _GamePlayingPauseMenu.selection > 1 then
				_GamePlayingPauseMenu.selection = _GamePlayingPauseMenu.selection - 1
			end
		elseif k == "return" then
			if _GamePlayingPauseMenu.selection == 1 then
				gamestate = gamestatePlayingGame
			elseif _GamePlayingPauseMenu.selection == 2 then
				gamestate = gamestatePlayingGameSettings
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
				gamestate = gamestateMainMenu
			end
		end
	end
	_JPROFILER.pop("keysinitGamePlayingPauseMenu")
end
function destroyPlayingPauseMenu()
	_GamePlayingPauseMenu = nil
end
