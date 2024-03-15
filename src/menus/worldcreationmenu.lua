function drawWorldCreationMenu()
	local w, h = lovegraphics.getDimensions()
	local scaleX = w / worldCreationBackground:getWidth()
	local scaleY = h / worldCreationBackground:getHeight()

	lovegraphics.draw(worldCreationBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _WorldCreationMenu.y
	local lineHeight = font15:getHeight("X")

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

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _WorldCreationMenu.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _WorldCreationMenu.x, posY)
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
				gamestate = gamestatePlayingGame
				GenerateWorld()
			elseif _WorldCreationMenu.selection == 2 then
				gamestate = gamestateMainMenu
				_WorldCreationMenu.selection = 0
			end
		end
	end
end

function destroyWorldCreationMenu()
	_WorldCreationMenu = nil
end
