--!draw.lua
function GamestateMainMenuDrawGame()
	if Gamestate == GamestateMainMenu then
		_JPROFILER.push("drawMainMenu")
		drawMainMenu()
		_JPROFILER.pop("drawMainMenu")
	end
end

--mouseandkeybindlogic.lua
function GamestateMainMenuMouseAndKeybindLogic(x, y, b)
	if Gamestate == GamestateMainMenu then
		if b == 1 then
			local choiceClicked = math.floor((y - _Mainmenu.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_Mainmenu.choice then
				_Mainmenu.selection = choiceClicked
				if choiceClicked == 1 then
					_WorldCreationMenu.selection = 0
					Gamestate = GamestateWorldCreationMenu
				elseif choiceClicked == 2 then
					Gamestate = GamestateMainMenuSettings
				elseif choiceClicked == 3 then
					love.event.push("quit")
				end
			end
		end
	end
end
