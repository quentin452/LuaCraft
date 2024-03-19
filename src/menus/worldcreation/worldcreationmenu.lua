function drawWorldCreationMenu()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / WorldCreationBackground:getWidth()
	local scaleY = h / WorldCreationBackground:getHeight()

	Lovegraphics.draw(WorldCreationBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _WorldCreationMenu.y
	local lineHeight = Font15:getHeight("X")

	-- Title Screen
	drawColorString(_WorldCreationMenu.title, _WorldCreationMenu.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	for n = 1, #_WorldCreationMenu.choice do
		if _WorldCreationMenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end

		local choiceText = _WorldCreationMenu.choice[n]
		drawColorString(marque .. "" .. choiceText, _WorldCreationMenu.x, posY)

		posY = posY + lineHeight
	end
end

function keysInitWorldCreationMenu(k)
	if type(_WorldCreationMenu.choice) == "table" and _WorldCreationMenu.selection then
		if k == "s" then
			if _WorldCreationMenu.selection < #_WorldCreationMenu.choice then
				_WorldCreationMenu.selection = _WorldCreationMenu.selection + 1
			end
		elseif k == "z" then
			if _WorldCreationMenu.selection > 1 then
				_WorldCreationMenu.selection = _WorldCreationMenu.selection - 1
			end
		elseif k == "return" then
			if _WorldCreationMenu.selection == 1 then
				Gamestate = GamestatePlayingGame
				love.mouse.setRelativeMode(true)
				GenerateWorld()
			elseif _WorldCreationMenu.selection == 2 then
				Gamestate = GamestateMainMenu
				_WorldCreationMenu.selection = 0
			end
		end
	end
end
