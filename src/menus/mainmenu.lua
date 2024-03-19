function drawMainMenu()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / MainMenuBackground:getWidth()
	local scaleY = h / MainMenuBackground:getHeight()

	Lovegraphics.draw(MainMenuBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _Mainmenu.y
	local lineHeight = Font25:getHeight("X")

	-- Title Screen
	drawColorString(_Mainmenu.title, _Mainmenu.x, posY)
	posY = posY + lineHeight

	-- Choices
	local marque = ""
	for n = 1, #_Mainmenu.choice do
		if _Mainmenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		drawColorString(marque .. "" .. _Mainmenu.choice[n], _Mainmenu.x, posY)
		posY = posY + lineHeight
	end
end

function keysinitMainMenu(k)
	if type(_Mainmenu.choice) == "table" and _Mainmenu.selection then
		if k == "s" then
			if _Mainmenu.selection < #_Mainmenu.choice then
				_Mainmenu.selection = _Mainmenu.selection + 1
			end
		elseif k == "z" then
			if _Mainmenu.selection > 1 then
				_Mainmenu.selection = _Mainmenu.selection - 1
			end
		elseif k == "return" then
			if _Mainmenu.selection == 1 then
				_WorldCreationMenu.selection = 0 --prevent https://github.com/quentin452/LuaCraft/issues/9
				Gamestate = GamestateWorldCreationMenu
			elseif _Mainmenu.selection == 2 then
				Gamestate = GamestateMainMenuSettings
			elseif _Mainmenu.selection == 3 then
				love.event.push("quit")
			end
		end
	end
end
