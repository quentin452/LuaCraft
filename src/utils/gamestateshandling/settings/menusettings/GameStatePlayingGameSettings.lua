GamestatePlayingGameSettings2 = GameStateBase:new()
local MenuTable = _MainMenuSettings

function GamestatePlayingGameSettings2:resetMenuSelection()
	MenuTable.selection = 1
end
function GamestatePlayingGameSettings2:draw()
	SharedSettingsDraw()
end
function GamestatePlayingGameSettings2:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, SharedSettingsPerformMenuAction)
end

function GamestatePlayingGameSettings2:keypressed(k)
	MenuTable.choice, MenuTable.selection = SharedSelectionKeyPressedBetweenGameState(
		k,
		MenuTable.choice,
		MenuTable.selection,
		SharedSettingsPerformMenuAction
	)
end
function GamestatePlayingGameSettings2:setFont()
	return Font25
end
function GamestatePlayingGameSettings2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
