--mouseandkeybindlogic.lua
function GamestateWorldCreationMenuMouseAndKeybindLogic(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _WorldCreationMenu.y) / Font15:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_WorldCreationMenu.choice then
			_WorldCreationMenu.selection = choiceClicked
			if choiceClicked == 1 then
				Gamestate = GamestatePlayingGame
				love.mouse.setRelativeMode(true)
				GenerateWorld()
			elseif choiceClicked == 2 then
				Gamestate = GamestateMainMenu
				_WorldCreationMenu.selection = 0
			end
		end
	end
end
