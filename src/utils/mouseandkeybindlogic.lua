function KeyPressed(k)
	if k == "f11" then
		LuaCraftSettingsUpdater("toggleFullScreen")
	end
	-- simplified hotbar number press code, thanks nico-abram!
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 and FixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = numberPress
	else
		LuaCraftCurrentGameState:keypressed(k)
	end
	if ConfiguringMovementKey then
		if k == "escape" then
			ConfiguringMovementKey = false
		else
			if k ~= "return" then
				local keyToUpdate
				if _KeybindingMenuSettings.selection == 1 then
					keyToUpdate = "forwardmovementkey"
				elseif _KeybindingMenuSettings.selection == 2 then
					keyToUpdate = "backwardmovementkey"
				elseif _KeybindingMenuSettings.selection == 3 then
					keyToUpdate = "leftmovementkey"
				elseif _KeybindingMenuSettings.selection == 4 then
					keyToUpdate = "rightmovementkey"
				end
				if keyToUpdate then
					local forwardKey
					local previousKey = forwardKey
					forwardKey = k
					updateConfigFile(keyToUpdate, forwardKey)
					if forwardKey ~= previousKey then
						ResetMovementKeys = true
						ConfiguringMovementKey = false
					end
				end
			end
		end
	end
end
