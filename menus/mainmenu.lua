_Mainmenu = {}
_Mainmenu.x = 50
_Mainmenu.y = 50
_Mainmenu.title = "LuaCraft"
_Mainmenu.choice = {}
_Mainmenu.choice[1] = "%2Play Game%0"
_Mainmenu.choice[2] = "Settings"
_Mainmenu.choice[3] = "Exit"
_Mainmenu.selection = 0 -- initialize to 0 to prevent unwanted object selection

function drawMainMenu()
	local w, h = love.graphics.getDimensions()
	local scaleX = w / mainMenuBackground:getWidth()
	local scaleY = h / mainMenuBackground:getHeight()

	love.graphics.draw(mainMenuBackground, 0, 0, 0, scaleX, scaleY)

	_font = love.graphics.newFont(25)
	love.graphics.setFont(_font)
	-- Main menu rendering code here

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
	if enableProfiler then
        ProFi:checkMemory(3, "Premier profil")
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
				gamestate = "PlayingGame"
				_font = love.graphics.newFont(15)
				love.graphics.setFont(_font)
			elseif _Mainmenu.selection == 2 then
				gamestate = "MainMenuSettings"
			elseif _Mainmenu.selection == 3 then
				love.event.push("quit")
			end
		end
	end
	if enableProfiler then
        ProFi:checkMemory(4, "Premier profil")
    end
end
