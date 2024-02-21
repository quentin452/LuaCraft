require("things/usefull")

_Mainmenu = {}
_Mainmenu.x = 50
_Mainmenu.y = 50
_Mainmenu.title = "LuaCraft"
_Mainmenu.choice = {}
_Mainmenu.choice[1] = "%2Play Game%0"
_Mainmenu.choice[2] = "Settings"
_Mainmenu.choice[3] = "Exit"
_Mainmenu.selection = 1

function drawMainMenu()
	love.graphics.draw(mainMenuBackground, 0, 0)
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
end
