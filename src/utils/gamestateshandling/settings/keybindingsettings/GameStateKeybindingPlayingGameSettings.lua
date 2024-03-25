GamestateKeybindingPlayingGameSettings2 = GameStateBase:new()
function GamestateKeybindingPlayingGameSettings2:resetMenuSelection()
	_KeybindingMenuSettings.selection = 1
end
function GamestateKeybindingPlayingGameSettings2:draw()
	SharedKeybindingSettingsDraw()
end

function GamestateKeybindingPlayingGameSettings2:mousepressed(x, y, b)
	SharedKeybindingSettingsMousePressed(x, y, b)
end

function GamestateKeybindingPlayingGameSettings2:keypressed(k)
	SharedKeybindingSettingsKeyPressed(k)
end

function GamestateKeybindingPlayingGameSettings2:setFont()
	return Font25
end

function GamestateKeybindingPlayingGameSettings2:resizeMenu()
	SharedKeybindingSettingsResizeMenu()
end
