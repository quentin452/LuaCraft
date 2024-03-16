function updateConfigFile(key, value)
	local fileContent, errorMessage = customReadFile(Luacraftconfig)
	if fileContent then
		fileContent = fileContent:gsub(key .. "=[%w]+", key .. "=" .. value)
		local file, err = io.open(Luacraftconfig, "w")
		if file then
			file:write(fileContent)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. err)
		end
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. errorMessage)
	end
end
function DrawKeybindingSettings()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / KeybindingSettingsBackground:getWidth()
	local scaleY = h / KeybindingSettingsBackground:getHeight()

	Lovegraphics.draw(KeybindingSettingsBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _KeybindingMenuSettings.y
	local lineHeight = Font25:getHeight("X")

	-- Title Screen
	drawColorString(_KeybindingMenuSettings.title, _KeybindingMenuSettings.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local Settings = {}
		local orderedKeys = { "forwardmovementkey", "backwardmovementkey", "leftmovementkey", "rightmovementkey" }

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
			drawColorString(marque .. "" .. choiceText, _KeybindingMenuSettings.x, posY)

			posY = posY + lineHeight
		end
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
end
function keysinitKeybindingSettings(k)
	if type(_KeybindingMenuSettings.choice) == "table" and _KeybindingMenuSettings.selection then
		if k == "s" and ConfiguringMovementKey == false then
			if _KeybindingMenuSettings.selection < #_KeybindingMenuSettings.choice then
				_KeybindingMenuSettings.selection = _KeybindingMenuSettings.selection + 1
			end
		elseif k == "z" and ConfiguringMovementKey == false then
			if _KeybindingMenuSettings.selection > 1 then
				_KeybindingMenuSettings.selection = _KeybindingMenuSettings.selection - 1
			end
		elseif k == "return" then
			if _KeybindingMenuSettings.selection == 1 then
				ConfiguringMovementKey = true
			elseif _KeybindingMenuSettings.selection == 2 then
				ConfiguringMovementKey = true
			elseif _KeybindingMenuSettings.selection == 3 then
				ConfiguringMovementKey = true
			elseif _KeybindingMenuSettings.selection == 4 then
				ConfiguringMovementKey = true
			elseif _KeybindingMenuSettings.selection == 5 then
				Gamestate = GamestateMainMenuSettings
				_KeybindingMenuSettings.selection = 0
			end
		end
	end
end

function destroyKeybindingSettings()
	_KeybindingMenuSettings = nil
end
