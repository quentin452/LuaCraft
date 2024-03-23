GamestateMainMenuSettings2 = GameStateBase:new()
function GamestateMainMenuSettings2:resetMenuSelection()
	_MainMenuSettings.selection = 1
end
function GamestateMainMenuSettings2:draw()
	SharedSettingsDraw()
end
function GamestateMainMenuSettings2:mousepressed(x, y, b)
	SharedSettingsMousePressed(x, y, b)
end

function GamestateMainMenuSettings2:keypressed(k)
	SharedSettingsKeyPressed(k)
end
function GamestateMainMenuSettings2:setFont()
	return Font25
end
