local _Mainmenu = CreateLuaCraftMenu(0, 0, "LuaCraft", {
	"%2World Creation Menu%0",
	"%3Test Unit Menu%0",
	"Settings",
	"Exit",
})
GamestateMainMenu2 = GameStateBase:new()

function GamestateMainMenu2:resetMenuSelection()
	_Mainmenu.selection = 1
end
local menuWidth = 0
function GamestateMainMenu2:resizeMenu()
	local newMenuWidth = 0
	for _, choice in ipairs(_Mainmenu.choice) do
		local choiceWidth = self:setFont():getWidth(choice)
		if choiceWidth > newMenuWidth then
			newMenuWidth = choiceWidth
		end
	end
	menuWidth = newMenuWidth
end

local marque = ""

function GamestateMainMenu2:draw()
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / MainMenuBackground:getWidth()
	local scaleY = h / MainMenuBackground:getHeight()
	Lovegraphics.draw(MainMenuBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = GetSelectedFont():getHeight("X")
	DrawColorString(_Mainmenu.title, posX, posY)
	posY = posY + lineHeight
	for n = 1, #_Mainmenu.choice do
		if _Mainmenu.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		DrawColorString(marque .. "" .. _Mainmenu.choice[n], posX, posY)
		posY = posY + lineHeight
	end
end

local function PerformMenuAction(action)
	if action == 1 then
		SetCurrentGameState(GamestateWorldCreationMenu2)
	elseif action == 2 then
		SetCurrentGameState(GameStateTestUnit)
	elseif action == 3 then
		SetCurrentGameState(GamestateMainMenuSettings2)
	elseif action == 4 then
		love.event.push("quit")
	end
end

function GamestateMainMenu2:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = GetSelectedFont():getHeight("X")

		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth

		if choiceClicked >= 1 and choiceClicked <= #_Mainmenu.choice and x >= minX and x <= maxX then
			_Mainmenu.selection = choiceClicked
			PerformMenuAction(choiceClicked)
		end
	end
end

function GamestateMainMenu2:keypressed(k)
	if k == BackWardKey then
		if _Mainmenu.selection < #_Mainmenu.choice then
			_Mainmenu.selection = _Mainmenu.selection + 1
		end
	elseif k == ForWardKey then
		if _Mainmenu.selection > 1 then
			_Mainmenu.selection = _Mainmenu.selection - 1
		end
	elseif k == "return" then
		PerformMenuAction(_Mainmenu.selection)
	end
end

function GamestateMainMenu2:setFont()
	return Font25
end
