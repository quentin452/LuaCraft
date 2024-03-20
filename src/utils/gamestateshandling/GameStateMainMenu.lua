GamestateMainMenu2 = GameStateBase:new()

function GamestateMainMenu2:draw()
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

function GamestateMainMenu2:mousepressed(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _Mainmenu.y) / Font25:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_Mainmenu.choice then
			_Mainmenu.selection = choiceClicked
			if choiceClicked == 1 then
				_WorldCreationMenu.selection = 0
				SetPlayingGamestateWorldCreationMenu2()
			elseif choiceClicked == 2 then
				SetPlayingGamestateMainMenuSettings2()
			elseif choiceClicked == 3 then
				love.event.push("quit")
			end
		end
	end
end
function GamestateMainMenu2:keypressed(k)
	if type(_Mainmenu.choice) == "table" and _Mainmenu.selection then
		if k == BackWardKey then
			if _Mainmenu.selection < #_Mainmenu.choice then
				_Mainmenu.selection = _Mainmenu.selection + 1
			end
		elseif k == ForWardKey then
			if _Mainmenu.selection > 1 then
				_Mainmenu.selection = _Mainmenu.selection - 1
			end
		elseif k == "return" then
			if _Mainmenu.selection == 1 then
				_WorldCreationMenu.selection = 0 --prevent https://github.com/quentin452/LuaCraft/issues/9
				SetPlayingGamestateWorldCreationMenu2()
			elseif _Mainmenu.selection == 2 then
				SetPlayingGamestateMainMenuSettings2()
			elseif _Mainmenu.selection == 3 then
				love.event.push("quit")
			end
		end
	end
end
