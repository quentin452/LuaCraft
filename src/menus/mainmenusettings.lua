_MainMenuSettings = {}
_MainMenuSettings.x = 50
_MainMenuSettings.y = 50
_MainMenuSettings.title = "Settings"
_MainMenuSettings.choice = {}
_MainMenuSettings.choice[1] = "Enable Vsync?"
_MainMenuSettings.choice[2] = "Enable Logging(no warn or errors)?"
_MainMenuSettings.choice[3] = "Enable warns logging?"
_MainMenuSettings.choice[4] = "Enable errors logging?"
_MainMenuSettings.choice[5] = "Render Distance"
_MainMenuSettings.choice[6] = "Exiting to main menu"
_MainMenuSettings.selection = 0 -- initialize to 0 to prevent unwanted object selection

function drawMainMenuSettings()
	local w, h = lovegraphics.getDimensions()
	local scaleX = w / mainMenuSettingsBackground:getWidth()
	local scaleY = h / mainMenuSettingsBackground:getHeight()

	lovegraphics.draw(mainMenuSettingsBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _MainMenuSettings.y
	local lineHeight = font25:getHeight("X")

	-- Title Screen
	drawColorString(_MainMenuSettings.title, _MainMenuSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	local file_content, error_message = customReadFile(luacraftconfig)

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

		for n = 1, #_MainMenuSettings.choice do
			if _MainMenuSettings.selection == n then
				marque = "%1*%0 "
			else
				marque = "   "
			end

			local choiceText = _MainMenuSettings.choice[n]
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
			drawColorString(marque .. "" .. choiceText, _MainMenuSettings.x, posY)

			posY = posY + lineHeight
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _MainMenuSettings.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _MainMenuSettings.x, posY)
end

function keysinitMainMenuSettings(k)
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
				toggleVSync()
			elseif _MainMenuSettings.selection == 2 then
				printNormalLoggingSettings()
			elseif _MainMenuSettings.selection == 3 then
				printWarnsSettings()
			elseif _MainMenuSettings.selection == 4 then
				printErrorsSettings()
			elseif _MainMenuSettings.selection == 5 then
				renderdistanceSetting()
				renderdistancegetresetted = true
			elseif _MainMenuSettings.selection == 6 then
				gamestate = gamestateMainMenu
				_MainMenuSettings.selection = 0
			end
		end
	end
end

function destroyMainMenuSettings()
	_MainMenuSettings = nil
end
