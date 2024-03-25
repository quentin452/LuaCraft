local _WorldCreationMenu = CreateLuaCraftMenu(0, 0, "World Creation Menu", {
	"Create World?",
	"WorldType",
	"Exiting to main menu",
})
local MenuTable = _WorldCreationMenu
GamestateWorldCreationMenu2 = GameStateBase:new()
function GamestateWorldCreationMenu2:resetMenuSelection()
	MenuTable.selection = 1
end
local marque = ""
function GamestateWorldCreationMenu2:draw()
	_JPROFILER.push("drawWorldCreationMenu")
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / WorldCreationBackground:getWidth()
	local scaleY = h / WorldCreationBackground:getHeight()
	Lovegraphics.draw(WorldCreationBackground, 0, 0, 0, scaleX, scaleY)
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
		local choiceText = MenuTable.choice[n]
		if n == 2 then
			local worldType = WorldTypeMap[GlobalWorldType]
			local worldTypeName = worldType.name
			DrawColorString(marque .. choiceText .. " (" .. worldTypeName .. ")", posX, posY)
		else
			DrawColorString(marque .. "" .. choiceText, posX, posY)
		end
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
		local worldType = WorldTypeMap[GlobalWorldType]
		if worldType and worldType.nextType then
			GlobalWorldType = worldType.nextType
		end
	elseif action == 3 then
		SetCurrentGameState(GamestateMainMenu2)
	end
end
function GamestateWorldCreationMenu2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
function GamestateWorldCreationMenu2:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GamestateWorldCreationMenu2:keypressed(k)
	MenuTable.choice, MenuTable.selection =
		SharedSelectionKeyPressedBetweenGameState(k, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end

function GamestateWorldCreationMenu2:setFont()
	return Font15
end
