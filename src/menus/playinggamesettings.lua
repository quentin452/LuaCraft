_PlayingGameSettings = {}
_PlayingGameSettings.x = 50
_PlayingGameSettings.y = 50
_PlayingGameSettings.title = "Settings"
_PlayingGameSettings.choice = {}
_PlayingGameSettings.choice[1] = "Enable Vsync?"
_PlayingGameSettings.choice[2] = "Enable Print Logging?"
_PlayingGameSettings.choice[3] = "Render Distance"
_PlayingGameSettings.choice[4] = "Exiting to game"
_PlayingGameSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection

function drawPlayingMenuSettings()
	local w, h = lovegraphics.getDimensions()
	local scaleX = w / playinggamesettings:getWidth()
	local scaleY = h / playinggamesettings:getHeight()

	lovegraphics.draw(playinggamesettings, 0, 0, 0, scaleX, scaleY)

	local posY = _PlayingGameSettings.y
	local lineHeight = font25:getHeight("X")

	-- Title Screen
	drawColorString(_PlayingGameSettings.title, _PlayingGameSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	local vsyncValue = lovefilesystem.read("config.conf"):match("vsync=(%w+)")
	local printValue = lovefilesystem.read("config.conf"):match("luacraftprint=(%w+)")
	local renderdistancevalue = lovefilesystem.read("config.conf"):match("renderdistance=(%d)")

	for n = 1, #_PlayingGameSettings.choice do
		if _PlayingGameSettings.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end

		local choiceText = _PlayingGameSettings.choice[n]
		if n == 1 and vsyncValue and vsyncValue:lower() == "true" then
			choiceText = choiceText .. " X"
		end

		if n == 2 and printValue and printValue:lower() == "true" then
			choiceText = choiceText .. " X"
		end

		if n == 3 and renderdistancevalue then
			choiceText = choiceText .. " " .. globalRenderDistance
		end
		drawColorString(marque .. "" .. choiceText, _PlayingGameSettings.x, posY)

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
				toggleVSync()
			elseif _PlayingGameSettings.selection == 2 then
				printSettings()
			elseif _PlayingGameSettings.selection == 3 then
				renderdistanceSetting()
			elseif _PlayingGameSettings.selection == 4 then
				gamestate = "PlayingGame"
				_PlayingGameSettings.selection = 0
			end
		end
	end
end

function destroyPlayingGameSettings()
	_PlayingGameSettings = nil
end
