local Settings = {}
local orderedKeys = { "forwardmovementkey", "backwardmovementkey", "leftmovementkey", "rightmovementkey" , "chatkey" }
local marque = ""

function SharedKeybindingSettingsDraw()
	_JPROFILER.push("drawMenuSettings")
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / KeybindingSettingsBackground:getWidth()
	local scaleY = h / KeybindingSettingsBackground:getHeight()
	Lovegraphics.draw(KeybindingSettingsBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = GetSelectedFont():getHeight("X")
	DrawColorString(_KeybindingMenuSettings.title, posX, posY)
	posY = posY + lineHeight
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		for _, key in ipairs(orderedKeys) do
			local value = file_content:match(key .. "=(%w+)")
			if value then
				Settings[key] = value
			end
		end
		for n = 1, #_KeybindingMenuSettings.choice do
			if _KeybindingMenuSettings.selection == n then
				marque = "%1*%0 "
			else
				marque = "   "
			end
			local choiceText = _KeybindingMenuSettings.choice[n]
			local numberOfSpaces = 1
			if n == 1 and Settings["forwardmovementkey"] then
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["forwardmovementkey"]
			end
			if n == 2 and Settings["backwardmovementkey"] then
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["backwardmovementkey"]
			end
			if n == 3 and Settings["leftmovementkey"] then
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["leftmovementkey"]
			end
			if n == 4 and Settings["rightmovementkey"] then
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["rightmovementkey"]
			end
			if n == 5 and Settings["chatkey"] then
				choiceText = choiceText .. string.rep(" ", numberOfSpaces) .. Settings["chatkey"]
			end
			DrawColorString(marque .. "" .. choiceText, posX, posY)
			posY = posY + lineHeight
		end
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Failed to read Luacraftconfig.txt. Error: " .. error_message,
		})
	end
	_JPROFILER.pop("drawMenuSettings")
end

function SharedKeybindingSettingsPerformMenuAction(action)
	if action == 1 then
		ConfiguringMovementKey_KeyPressed = true
	elseif action == 2 then
		ConfiguringMovementKey_KeyPressed = true
	elseif action == 3 then
		ConfiguringMovementKey_KeyPressed = true
	elseif action == 4 then
		ConfiguringMovementKey_KeyPressed = true
	elseif action == 5 then
		ConfiguringMovementKey_KeyPressed = true
	elseif action == 6 then
		if IsCurrentGameState(GamestateKeybindingMainSettings2) then
			SetCurrentGameState(GamestateMainMenuSettings2)
		elseif IsCurrentGameState(GamestateKeybindingPlayingGameSettings2) then
			SetCurrentGameState(GamestatePlayingGameSettings2)
		end
	end
end
