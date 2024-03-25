GamestateMainMenuSettings2 = GameStateBase:new()
local MenuTable = _MainMenuSettings
function GamestateMainMenuSettings2:resetMenuSelection()
	MenuTable.selection = 1
end
function GamestateMainMenuSettings2:draw()
	SharedSettingsDraw()
end
function GamestateMainMenuSettings2:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, SharedSettingsPerformMenuAction)
end

function GamestateMainMenuSettings2:keypressed(k)
	MenuTable.choice, MenuTable.selection = SharedSelectionKeyPressedBetweenGameState(
		k,
		MenuTable.choice,
		MenuTable.selection,
		SharedSettingsPerformMenuAction
	)
end

function GamestateMainMenuSettings2:setFont()
	return Font25
end
function GamestateMainMenuSettings2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
