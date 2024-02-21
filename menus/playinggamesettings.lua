_PlayingGameSettings = {}
_PlayingGameSettings.x = 50
_PlayingGameSettings.y = 50
_PlayingGameSettings.title = "Settings"
_PlayingGameSettings.choice = {}
_PlayingGameSettings.choice[1] = "Enable Vsync?"
_PlayingGameSettings.choice[2] = "Exiting to game"
_PlayingGameSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection

local vsync = love.window.getVSync()

function drawPlayingMenuSettings()
	local w, h = love.graphics.getDimensions()
	local scaleX = w / playinggamesettings:getWidth()
	local scaleY = h / playinggamesettings:getHeight()

	love.graphics.draw(playinggamesettings, 0, 0, 0, scaleX, scaleY)
	_font = love.graphics.newFont(25)
	love.graphics.setFont(_font)
	-- Main menu rendering code here

	local posY = _PlayingGameSettings.y
	local lineHeight = _font:getHeight("X")

	-- Title Screen
	drawColorString(_PlayingGameSettings.title, _PlayingGameSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	for n = 1, #_PlayingGameSettings.choice do
		if _PlayingGameSettings.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		drawColorString(marque .. "" .. _PlayingGameSettings.choice[n], _PlayingGameSettings.x, posY)
		posY = posY + lineHeight
	end

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _PlayingGameSettings.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _PlayingGameSettings.x, posY)
end

function keysinitPlayingMenuSettings(k)
	if type(_PlayingGameSettings.choice) == "table" and _PlayingGameSettings.selection then
		if k == "s" then
			if _PlayingGameSettings.selection < #_PlayingGameSettings.choice then
				_PlayingGameSettings.selection = _PlayingGameSettings.selection + 1
			end
		elseif k == "z" then
			if _PlayingGameSettings.selection > 1 then
				_PlayingGameSettings.selection = _PlayingGameSettings.selection - 1
			end
		elseif k == "return" then
			if _PlayingGameSettings.selection == 1 then
				vsync = not vsync
				love.window.setVSync(vsync)
			elseif _PlayingGameSettings.selection == 2 then
				gamestate = "PlayingGame"
				_PlayingGameSettings.selection = 0
				_font = love.graphics.newFont(15)
				love.graphics.setFont(_font)
			end
		end
	end
end
