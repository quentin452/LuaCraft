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
	local w, h = love.graphics.getDimensions()
	local scaleX = w / gameplayingpausemenu:getWidth()
	local scaleY = h / gameplayingpausemenu:getHeight()

	love.graphics.draw(gameplayingpausemenu, 0, 0, 0, scaleX, scaleY)
	_font = love.graphics.newFont(25)
	love.graphics.setFont(_font)
	-- Main menu rendering code here

	local posY = _GamePlayingPauseMenu.y
	local lineHeight = _font:getHeight("X")

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
				gamestate = "PlayingGame"
				_font = love.graphics.newFont(15)
				love.graphics.setFont(_font)
			elseif _GamePlayingPauseMenu.selection == 2 then
				gamestate = "PlayingGameSettings"
			elseif _GamePlayingPauseMenu.selection == 3 then
				gameSceneInstance:destroy()
				gamestate = "MainMenu"
				_GamePlayingPauseMenu.selection = 0
			end
		end
	end
end
function destroyPlayingPauseMenu()
	_GamePlayingPauseMenu = nil
end
