
_Mainmenu = {}
_Mainmenu.x = 50
_Mainmenu.y = 50
_Mainmenu.title = "Voxel3DGame"
_Mainmenu.choice = {}
_Mainmenu.choice[1] = "%2Play Game%0"
_Mainmenu.choice[2] = "Settings"
_Mainmenu.choice[3] = "Exit"
_Mainmenu.selection = 1
_font = love.graphics.newFont(25)

function drawColorString(Pstring, Px, Py)
	local rx = Px
	local ry = Py

	love.graphics.setColor(255, 255, 255) --white
	--local ignore is to remove the caracteres after the % on the rendering
	local ignore = 0
	for i = 1, string.len(Pstring) do
		if ignore == 0 then
			local c = string.sub(Pstring, i, i)

			if c == "%" then
				ignore = 1
				local color = string.sub(Pstring, i + 1, i + 1)
				if color == "3" then
					love.graphics.setColor(0, 255, 255) --blue
				else
					if color == "2" then
						love.graphics.setColor(0, 255, 0) --green
					else
						if color == "1" then
							love.graphics.setColor(255, 0, 0) --red
						else
							if color == "0" then
								love.graphics.setColor(255, 255, 255) --white
							end
						end
					end
				end
			else
				--render string without %
				love.graphics.print(c, rx, ry)
				--if i don't use rx = rx + _font:getWidth(c) all caracteres will be at same location
				rx = rx + _font:getWidth(c)
			end
		else
			ignore = ignore - 1
		end
	end
	-- love.graphics.print(Pstring,Px,Py)
end

function drawMainMenu()
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
