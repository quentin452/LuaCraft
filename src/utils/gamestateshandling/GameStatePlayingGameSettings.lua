GamestatePlayingGameSettings2 = GameStateBase:new()
function GamestatePlayingGameSettings2:resetMenuSelection()
	_MainMenuSettings.selection = 1
end
function GamestatePlayingGameSettings2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / MainMenuSettingsBackground:getWidth()
	local scaleY = h / MainMenuSettingsBackground:getHeight()
	Lovegraphics.draw(MainMenuSettingsBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = getSelectedFont():getHeight("X")
	drawColorString(_MainMenuSettings.title, posX, posY)
	posY = posY + lineHeight
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
			drawColorString(marque .. "" .. choiceText, posX, posY)

			posY = posY + lineHeight
		end
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Failed to read Luacraftconfig.txt. Error: " .. error_message,
		})
	end
end

local function PerformMenuAction(action)
	if action == 1 then
		LuaCraftSettingsUpdater("toggleVSync")
	elseif action == 2 then
		LuaCraftSettingsUpdater("NormalLoggingToggler")
		ThreadLogChannel:supply({ "ResetLoggerKeys", false })
	elseif action == 3 then
		LuaCraftSettingsUpdater("WarnLoggingToggler")
		ThreadLogChannel:supply({ "ResetLoggerKeys", false })
	elseif action == 4 then
		LuaCraftSettingsUpdater("ErrorLoggingToggler")
		ThreadLogChannel:supply({ "ResetLoggerKeys", false })
	elseif action == 5 then
		LuaCraftSettingsUpdater("renderdistanceSetting")
		Renderdistancegetresetted = true
	elseif action == 6 then
		SetCurrentGameState(GamestateKeybindingPlayingGameSettings2)
	elseif action == 7 then
		WorldSuccessfullyLoaded = true
		SetCurrentGameState(GameStatePlayingGame2)
		love.mouse.setRelativeMode(true)
	end
end

function GamestatePlayingGameSettings2:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = getSelectedFont():getHeight("X")
		local menuWidth = 0
		for _, choice in ipairs(_MainMenuSettings.choice) do
			local choiceWidth = getSelectedFont():getWidth(choice)
			if choiceWidth > menuWidth then
				menuWidth = choiceWidth
			end
		end
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if choiceClicked >= 1 and choiceClicked <= #_MainMenuSettings.choice and x >= minX and x <= maxX then
			_MainMenuSettings.selection = choiceClicked
			PerformMenuAction(choiceClicked)
		end
	end
end
function GamestatePlayingGameSettings2:keypressed(k)
	if k == BackWardKey then
		if _MainMenuSettings.selection < #_MainMenuSettings.choice then
			_MainMenuSettings.selection = _MainMenuSettings.selection + 1
		end
	elseif k == ForWardKey then
		if _MainMenuSettings.selection > 1 then
			_MainMenuSettings.selection = _MainMenuSettings.selection - 1
		end
	elseif k == "return" then
		PerformMenuAction(_MainMenuSettings.selection)
	end
end
function GamestatePlayingGameSettings2:setFont()
	return Font25
end
