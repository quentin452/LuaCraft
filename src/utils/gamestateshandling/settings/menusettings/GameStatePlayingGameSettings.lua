GamestatePlayingGameSettings2 = GameStateBase:new()
function GamestatePlayingGameSettings2:resetMenuSelection()
	_MainMenuSettings.selection = 1
end
function GamestatePlayingGameSettings2:draw()
	SharedSettingsDraw()
end

function GamestatePlayingGameSettings2:mousepressed(x, y, b)
	SharedSettingsMousePressed(x, y, b)
end
function GamestatePlayingGameSettings2:keypressed(k)
	SharedSettingsKeyPressed(k)
end
function GamestatePlayingGameSettings2:setFont()
	return Font25
end
function GamestatePlayingGameSettings2:resizeMenu()
	SharedSettingsResizeMenu()
end
