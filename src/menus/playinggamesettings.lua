function drawPlayingMenuSettings()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / PlayingGameSettings:getWidth()
	local scaleY = h / PlayingGameSettings:getHeight()

	Lovegraphics.draw(PlayingGameSettings, 0, 0, 0, scaleX, scaleY)

	local posY = _PlayingGameSettings.y
	local lineHeight = Font25:getHeight("X")

	-- Title Screen
	drawColorString(_PlayingGameSettings.title, _PlayingGameSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local Settings = {}
		local orderedKeys =
			{ "vsync", "LuaCraftPrintLoggingNormal", "LuaCraftWarnLogging", "LuaCraftErrorLogging", "renderdistance" }

		for _, key in ipairs(orderedKeys) do
			local value = file_content:match(key .. "=(%w+)")
			if value then
				local numValue = tonumber(value)
				Settings[key] = numValue or (value == "true")
			end
		end

		for n = 1, #_PlayingGameSettings.choice do
			if _PlayingGameSettings.selection == n then
				marque = "%1*%0 "
			else
				marque = "   "
			end

			local choiceText = _PlayingGameSettings.choice[n]
			if n == 1 and Settings["vsync"] then
				choiceText = choiceText .. " X"
			end

			if n == 2 and Settings["LuaCraftPrintLoggingNormal"] then
				choiceText = choiceText .. " X"
			end
			if n == 3 and Settings["LuaCraftWarnLogging"] then
				choiceText = choiceText .. " X"
			end
			if n == 4 and Settings["LuaCraftErrorLogging"] then
				choiceText = choiceText .. " X"
			end

			if n == 5 and type(Settings["renderdistance"]) == "number" then
				local numberOfSpaces = 1
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["renderdistance"]
			end
			drawColorString(marque .. "" .. choiceText, _PlayingGameSettings.x, posY)

			posY = posY + lineHeight
		end
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
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
				printNormalLoggingSettings()
			elseif _PlayingGameSettings.selection == 3 then
				printWarnsSettings()
			elseif _PlayingGameSettings.selection == 4 then
				printErrorsSettings()
			elseif _PlayingGameSettings.selection == 5 then
				renderdistanceSetting()
				Renderdistancegetresetted = true
			elseif _PlayingGameSettings.selection == 6 then
				Gamestate = GamestatePlayingGame
				_PlayingGameSettings.selection = 0
			end
		end
	end
end

function destroyPlayingGameSettings()
	_PlayingGameSettings = nil
end
