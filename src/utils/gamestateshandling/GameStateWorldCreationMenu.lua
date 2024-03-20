local _WorldCreationMenu = CreateLuaCraftMenu(0, 0, "World Creation Menu", {
	"Create World?",
	"Exiting to main menu",
})

GamestateWorldCreationMenu2 = GameStateBase:new()
function GamestateWorldCreationMenu2:resetMenuSelection()
	_WorldCreationMenu.selection = 1
end
function GamestateWorldCreationMenu2:draw()
	_JPROFILER.push("drawWorldCreationMenu")
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / WorldCreationBackground:getWidth()
	local scaleY = h / WorldCreationBackground:getHeight()
	Lovegraphics.draw(WorldCreationBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = Font15:getHeight("X")
	drawColorString(_WorldCreationMenu.title, posX, posY)
	posY = posY + lineHeight

	local marque = ""
	for n = 1, #_WorldCreationMenu.choice do
		if _WorldCreationMenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		local choiceText = _WorldCreationMenu.choice[n]
		drawColorString(marque .. "" .. choiceText, posX, posY)
		posY = posY + lineHeight
	end

	_JPROFILER.pop("drawWorldCreationMenu")
end

local function PerformMenuAction(action)
	if action == 1 then
		SetCurrentGameState(GameStatePlayingGame2)
		love.mouse.setRelativeMode(true)
		GenerateWorld()
	elseif action == 2 then
		SetCurrentGameState(GamestateMainMenu2)
	end
end

function GamestateWorldCreationMenu2:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = Font15:getHeight("X")
		local menuWidth = 0
		for _, choice in ipairs(_WorldCreationMenu.choice) do
			local choiceWidth = Font15:getWidth(choice)
			if choiceWidth > menuWidth then
				menuWidth = choiceWidth
			end
		end
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if choiceClicked >= 1 and choiceClicked <= #_WorldCreationMenu.choice and x >= minX and x <= maxX then
			_WorldCreationMenu.selection = choiceClicked
			PerformMenuAction(choiceClicked)
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
			PerformMenuAction(_WorldCreationMenu.selection)
		end
	end
end

function GamestateWorldCreationMenu2:setFont()
	return Font15
end
