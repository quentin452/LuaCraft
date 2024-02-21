_MainMenuSettings = {}
_MainMenuSettings.x = 50
_MainMenuSettings.y = 50
_MainMenuSettings.title = "Settings"
_MainMenuSettings.choice = {}
_MainMenuSettings.choice[1] = "Enable Vsync?"
_MainMenuSettings.choice[2] = "Exiting to main menu"
_MainMenuSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection

local vsync = love.window.getVSync()

function drawMainMenuSettings()
	if not _MainMenuSettings then
		_MainMenuSettings = {}
		_MainMenuSettings.x = 50
		_MainMenuSettings.y = 50
		_MainMenuSettings.title = "Settings"
		_MainMenuSettings.choice = {}
		_MainMenuSettings.choice[1] = "Enable Vsync?"
		_MainMenuSettings.choice[2] = "Exiting to main menu"
		_MainMenuSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection
	end
	local w, h = love.graphics.getDimensions()
	local scaleX = w / mainMenuSettingsBackground:getWidth()
	local scaleY = h / mainMenuSettingsBackground:getHeight()

	love.graphics.draw(mainMenuSettingsBackground, 0, 0, 0, scaleX, scaleY)
	_font = love.graphics.newFont(25)
	love.graphics.setFont(_font)
	-- Main menu rendering code here

	local posY = _MainMenuSettings.y
	local lineHeight = _font:getHeight("X")

	-- Title Screen
	drawColorString(_MainMenuSettings.title, _MainMenuSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	for n = 1, #_MainMenuSettings.choice do
		if _MainMenuSettings.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		drawColorString(marque .. "" .. _MainMenuSettings.choice[n], _MainMenuSettings.x, posY)
		posY = posY + lineHeight
	end

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _MainMenuSettings.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _MainMenuSettings.x, posY)
end

function keysinitMainMenuSettings(k)
	if not _MainMenuSettings then
		_MainMenuSettings = {}
		_MainMenuSettings.x = 50
		_MainMenuSettings.y = 50
		_MainMenuSettings.title = "Settings"
		_MainMenuSettings.choice = {}
		_MainMenuSettings.choice[1] = "Enable Vsync?"
		_MainMenuSettings.choice[2] = "Exiting to main menu"
		_MainMenuSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection
	end
	if type(_MainMenuSettings.choice) == "table" and _MainMenuSettings.selection then
		if k == "s" then
			if _MainMenuSettings.selection < #_MainMenuSettings.choice then
				_MainMenuSettings.selection = _MainMenuSettings.selection + 1
			end
		elseif k == "z" then
			if _MainMenuSettings.selection > 1 then
				_MainMenuSettings.selection = _MainMenuSettings.selection - 1
			end
		elseif k == "return" then
			if _MainMenuSettings.selection == 1 then
				vsync = not vsync
				love.window.setVSync(vsync)
			elseif _MainMenuSettings.selection == 2 then
				gamestate = "MainMenu"
				_MainMenuSettings.selection = 0
			end
		end
	end
end

function destroyMainMenuSettings()
	_MainMenuSettings = nil
end
