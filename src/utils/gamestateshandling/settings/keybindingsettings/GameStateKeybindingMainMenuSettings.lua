GamestateKeybindingMainSettings2 = GameStateBase:new()
local MenuTable = _KeybindingMenuSettings

function GamestateKeybindingMainSettings2:resetMenuSelection()
	_KeybindingMenuSettings.selection = 1
end
function GamestateKeybindingMainSettings2:draw()
	SharedKeybindingSettingsDraw()
end

function GamestateKeybindingMainSettings2:mousepressed(x, y, b)
	MenuTable.choice, MenuTable.selection = SharedSelectionMenuBetweenGameState(
		x,
		y,
		b,
		MenuTable.choice,
		MenuTable.selection,
		SharedKeybindingSettingsPerformMenuAction
	)
end

function GamestateKeybindingMainSettings2:keypressed(k)
	MenuTable.choice, MenuTable.selection = SharedSelectionKeyPressedBetweenGameState(
		k,
		MenuTable.choice,
		MenuTable.selection,
		SharedKeybindingSettingsPerformMenuAction
	)
end

function GamestateKeybindingMainSettings2:setFont()
	return Font25
end

function GamestateKeybindingMainSettings2:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
