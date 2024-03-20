GamestatePlayingGameSettings2 = GameStateBase:new()

function GamestatePlayingGameSettings2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / MainMenuSettingsBackground:getWidth()
	local scaleY = h / MainMenuSettingsBackground:getHeight()

	Lovegraphics.draw(MainMenuSettingsBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _MainMenuSettings.y
	local lineHeight = Font25:getHeight("X")

	-- Title Screen
	drawColorString(_MainMenuSettings.title, _MainMenuSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local Settings = {}
		local orderedKeys = {
			"vsync",
			"LuaCraftPrintLoggingNormal",
			"LuaCraftWarnLogging",
			"LuaCraftErrorLogging",
			"renderdistance",
		}

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
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Failed to read Luacraftconfig.txt. Error: " .. error_message,
		})
	end
end

function GamestatePlayingGameSettings2:mousepressed(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _MainMenuSettings.y) / Font25:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_MainMenuSettings.choice then
			_MainMenuSettings.selection = choiceClicked
			if choiceClicked == 1 then
				LuaCraftSettingsUpdater("toggleVSync")
			elseif choiceClicked == 2 then
				LuaCraftSettingsUpdater("NormalLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif choiceClicked == 3 then
				LuaCraftSettingsUpdater("WarnLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif choiceClicked == 4 then
				LuaCraftSettingsUpdater("ErrorLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif choiceClicked == 5 then
				LuaCraftSettingsUpdater("renderdistanceSetting")
				Renderdistancegetresetted = true
			elseif choiceClicked == 6 then
				SetPlayingGamestateKeybindingPlayingGameSettings2()
				_MainMenuSettings.selection = 0
			elseif choiceClicked == 7 then
				SetPlayingGameStatePlayingGame2()
				love.mouse.setRelativeMode(true)
				_MainMenuSettings.selection = 0
			end
		end
	end
end

function GamestatePlayingGameSettings2:keypressed(k)
	if type(_MainMenuSettings.choice) == "table" and _MainMenuSettings.selection then
		if k == BackWardKey then
			if _MainMenuSettings.selection < #_MainMenuSettings.choice then
				_MainMenuSettings.selection = _MainMenuSettings.selection + 1
			end
		elseif k == ForWardKey then
			if _MainMenuSettings.selection > 1 then
				_MainMenuSettings.selection = _MainMenuSettings.selection - 1
			end
		elseif k == "return" then
			if _MainMenuSettings.selection == 1 then
				LuaCraftSettingsUpdater("toggleVSync")
			elseif _MainMenuSettings.selection == 2 then
				LuaCraftSettingsUpdater("NormalLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif _MainMenuSettings.selection == 3 then
				LuaCraftSettingsUpdater("WarnLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif _MainMenuSettings.selection == 4 then
				LuaCraftSettingsUpdater("ErrorLoggingToggler")
				ThreadLogChannel:supply({ "ResetLoggerKeys", false })
			elseif _MainMenuSettings.selection == 5 then
				LuaCraftSettingsUpdater("renderdistanceSetting")
				Renderdistancegetresetted = true
			elseif _MainMenuSettings.selection == 6 then
				SetPlayingGamestateKeybindingPlayingGameSettings2()
				_MainMenuSettings.selection = 0
			elseif _MainMenuSettings.selection == 7 then
				SetPlayingGameStatePlayingGame2()
				love.mouse.setRelativeMode(true)
				_MainMenuSettings.selection = 0
			end
		end
	end
end
