GamestateKeybindingPlayingGameSettings2 = GameStateBase:new()
function GamestateKeybindingPlayingGameSettings2:resetMenuSelection()
	_KeybindingMenuSettings.selection = 1
end
function GamestateKeybindingPlayingGameSettings2:draw()
	_JPROFILER.push("drawMenuSettings")
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / KeybindingSettingsBackground:getWidth()
	local scaleY = h / KeybindingSettingsBackground:getHeight()
	Lovegraphics.draw(KeybindingSettingsBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = self:setFont():getHeight("X")
	drawColorString(_KeybindingMenuSettings.title, posX, posY)
	posY = posY + lineHeight
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
			drawColorString(marque .. "" .. choiceText, posX, posY)
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

local function PerformMenuAction(action)
	if action == 1 then
		ConfiguringMovementKey = true
	elseif action == 2 then
		ConfiguringMovementKey = true
	elseif action == 3 then
		ConfiguringMovementKey = true
	elseif action == 4 then
		ConfiguringMovementKey = true
	elseif action == 5 then
		SetCurrentGameState(GamestatePlayingGameSettings2)
	end
end
function GamestateKeybindingPlayingGameSettings2:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = self:setFont():getHeight("X")
		local menuWidth = 0
		for _, choice in ipairs(_KeybindingMenuSettings.choice) do
			local choiceWidth = self:setFont():getWidth(choice)
			if choiceWidth > menuWidth then
				menuWidth = choiceWidth
			end
		end
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if choiceClicked >= 1 and choiceClicked <= #_KeybindingMenuSettings.choice and x >= minX and x <= maxX then
			_KeybindingMenuSettings.selection = choiceClicked
			PerformMenuAction(choiceClicked)
		end
	end
end


function GamestateKeybindingPlayingGameSettings2:keypressed(k)
	if type(_KeybindingMenuSettings.choice) == "table" and _KeybindingMenuSettings.selection then
		if k == BackWardKey and ConfiguringMovementKey == false then
			if _KeybindingMenuSettings.selection < #_KeybindingMenuSettings.choice then
				_KeybindingMenuSettings.selection = _KeybindingMenuSettings.selection + 1
			end
		elseif k == ForWardKey and ConfiguringMovementKey == false then
			if _KeybindingMenuSettings.selection > 1 then
				_KeybindingMenuSettings.selection = _KeybindingMenuSettings.selection - 1
			end
		elseif k == "return" then
			PerformMenuAction(_KeybindingMenuSettings.selection)
		end
	end
end

function GamestateKeybindingPlayingGameSettings2:setFont()
	return Font25
end
