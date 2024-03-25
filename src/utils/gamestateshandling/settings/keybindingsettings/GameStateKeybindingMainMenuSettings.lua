GamestateKeybindingMainSettings2 = GameStateBase:new()
function GamestateKeybindingMainSettings2:resetMenuSelection()
	_KeybindingMenuSettings.selection = 1
end
function GamestateKeybindingMainSettings2:draw()
	SharedKeybindingSettingsDraw()
end

function GamestateKeybindingMainSettings2:mousepressed(x, y, b)
	SharedKeybindingSettingsMousePressed(x, y, b)
end

function GamestateKeybindingMainSettings2:keypressed(k)
	SharedKeybindingSettingsKeyPressed(k)
end

function GamestateKeybindingMainSettings2:setFont()
	return Font25
end
function GamestateKeybindingMainSettings2:resizeMenu()
	SharedKeybindingSettingsResizeMenu()
end
