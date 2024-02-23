_Mainmenu = {}
_Mainmenu.x = 50
_Mainmenu.y = 50
_Mainmenu.title = "LuaCraft"
_Mainmenu.choice = {}
_Mainmenu.choice[1] = "%2World Creation Menu%0"
_Mainmenu.choice[2] = "Settings"
_Mainmenu.choice[3] = "Exit"
_Mainmenu.selection = 1

function drawMainMenu()
	local w, h = love.graphics.getDimensions()
	local scaleX = w / mainMenuBackground:getWidth()
	local scaleY = h / mainMenuBackground:getHeight()

	love.graphics.draw(mainMenuBackground, 0, 0, 0, scaleX, scaleY)

	local posY = _Mainmenu.y
	local lineHeight = _font:getHeight("X")

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

	-- Help
	--drawColorString("   [%3Fleches%0] Move the Selection", _Mainmenu.x, posY)
	--posY = posY + lineHeight
	--drawColorString("   [%3Retour%0] Valider", _Mainmenu.x, posY)
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
				gamestate = "WorldCreationMenu"
			elseif _Mainmenu.selection == 2 then
				gamestate = "MainMenuSettings"
			elseif _Mainmenu.selection == 3 then
				love.event.push("quit")
			end
		end
	end
end

function destroyMainMenu()
	_Mainmenu = nil
end
