GamestateWorldCreationMenu2 = GameStateBase:new()

function GamestateWorldCreationMenu2:draw()
	_JPROFILER.push("drawWorldCreationMenu")
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
	_JPROFILER.pop("drawWorldCreationMenu")
end

function GamestateWorldCreationMenu2:mousepressed(x, y, b)
	if b == 1 then
		local choiceClicked = math.floor((y - _WorldCreationMenu.y) / Font15:getHeight("X"))
		if choiceClicked >= 1 and choiceClicked <= #_WorldCreationMenu.choice then
			_WorldCreationMenu.selection = choiceClicked
			if choiceClicked == 1 then
				SetCurrentGameState(GameStatePlayingGame2)
				love.mouse.setRelativeMode(true)
				GenerateWorld()
			elseif choiceClicked == 2 then
				SetCurrentGameState(GamestateMainMenu2)
				_WorldCreationMenu.selection = 1
			end
		end
	end
end

function GamestateWorldCreationMenu2:keypressed(k)
	if type(_WorldCreationMenu.choice) == "table" and _WorldCreationMenu.selection then
		if k == BackWardKey then
			if _WorldCreationMenu.selection < #_WorldCreationMenu.choice then
				_WorldCreationMenu.selection = _WorldCreationMenu.selection + 1
			end
		elseif k == ForWardKey then
			if _WorldCreationMenu.selection > 1 then
				_WorldCreationMenu.selection = _WorldCreationMenu.selection - 1
			end
		elseif k == "return" then
			if _WorldCreationMenu.selection == 1 then
				SetCurrentGameState(GameStatePlayingGame2)
				love.mouse.setRelativeMode(true)
				GenerateWorld()
			elseif _WorldCreationMenu.selection == 2 then
				SetCurrentGameState(GamestateMainMenu2)
				_WorldCreationMenu.selection = 1
			end
		end
	end
end
