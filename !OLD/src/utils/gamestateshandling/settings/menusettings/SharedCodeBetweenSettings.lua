local Settings = {}
local orderedKeys = {
	"vsync",
	"LuaCraftPrintLoggingNormal",
	"LuaCraftWarnLogging",
	"LuaCraftErrorLogging",
	"renderdistance",
}
local marque = ""
function SharedSettingsDraw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / MainMenuSettingsBackground:getWidth()
	local scaleY = h / MainMenuSettingsBackground:getHeight()
	Lovegraphics.draw(MainMenuSettingsBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = GetSelectedFont():getHeight("X")
	DrawColorString(_MainMenuSettings.title, posX, posY)
	posY = posY + lineHeight
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
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
			DrawColorString(marque .. "" .. choiceText, posX, posY)

			posY = posY + lineHeight
		end
	else
		LuaCraftLoggingFunc(LuaCraftLoggingLevel.ERROR, "Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
end

function SharedSettingsPerformMenuAction(action)
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
		if IsCurrentGameState(GamestatePlayingGameSettings2) then
			SetCurrentGameState(GamestateKeybindingPlayingGameSettings2)
		elseif IsCurrentGameState(GamestateMainMenuSettings2) then
			SetCurrentGameState(GamestateKeybindingMainSettings2)
		end
	elseif action == 7 then
		WorldSuccessfullyLoaded = true
		if IsCurrentGameState(GamestatePlayingGameSettings2) then
			SetCurrentGameState(GameStatePlayingGame2)
		elseif IsCurrentGameState(GamestateMainMenuSettings2) then
			SetCurrentGameState(GamestateMainMenu2)
		end
	end
end
