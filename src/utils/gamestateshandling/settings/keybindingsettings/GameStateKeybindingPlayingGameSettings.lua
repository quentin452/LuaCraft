GamestateKeybindingPlayingGameSettings2 = GameStateBase:new()
local MenuTable = _KeybindingMenuSettings

function GamestateKeybindingPlayingGameSettings2:resetMenuSelection()
	_KeybindingMenuSettings.selection = 1
end
function GamestateKeybindingPlayingGameSettings2:draw()
	SharedKeybindingSettingsDraw()
end

function GamestateKeybindingPlayingGameSettings2:mousepressed(x, y, b)
	MenuTable.choice, MenuTable.selection = SharedSelectionMenuBetweenGameState(
		x,
		y,
		b,
		MenuTable.choice,
		MenuTable.selection,
		SharedKeybindingSettingsPerformMenuAction
	)
end

function GamestateKeybindingPlayingGameSettings2:keypressed(k)
	MenuTable.choice, MenuTable.selection = SharedSelectionKeyPressedBetweenGameState(
		k,
		MenuTable.choice,
		MenuTable.selection,
		SharedKeybindingSettingsPerformMenuAction
	)
end

function GamestateKeybindingPlayingGameSettings2:setFont()
	return Font25
end

function GamestateKeybindingPlayingGameSettings2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
