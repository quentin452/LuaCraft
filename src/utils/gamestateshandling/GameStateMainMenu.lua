local _Mainmenu = CreateLuaCraftMenu(0, 0, "LuaCraft", {
	"%2World Creation Menu%0",
	"%3Test Unit Menu%0",
	"Settings",
	"Exit",
})
local MenuTable = _Mainmenu
GamestateMainMenu2 = GameStateBase:new()

function GamestateMainMenu2:resetMenuSelection()
	MenuTable.selection = 1
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
	DrawColorString(MenuTable.title, posX, posY)
	posY = posY + lineHeight
	for n = 1, #MenuTable.choice do
		if MenuTable.selection == n then
			marque = "%1*%0 "
		else
			marque = "   "
		end
		DrawColorString(marque .. "" .. MenuTable.choice[n], posX, posY)
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

function GamestateMainMenu2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
function GamestateMainMenu2:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GamestateMainMenu2:keypressed(k)
	MenuTable.choice, MenuTable.selection =
		SharedSelectionKeyPressedBetweenGameState(k, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GamestateMainMenu2:setFont()
	return Font25
end
