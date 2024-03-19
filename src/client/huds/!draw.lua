require("src/client/huds/drawhud")
require("src/client/huds/tests/drawhudtest")
function DrawGame()
	setFont()
	if Gamestate == GamestateGamePausing then
		_JPROFILER.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		_JPROFILER.pop("drawGamePlayingPauseMenu")
	elseif Gamestate == GamestateWorldCreationMenu then
		_JPROFILER.push("drawWorldCreationMenu")
		drawWorldCreationMenu()
		_JPROFILER.pop("drawWorldCreationMenu")
	elseif Gamestate == GamestateMainMenuSettings or Gamestate == GamestatePlayingGameSettings then
		_JPROFILER.push("drawMenuSettings")
		DrawMenuSettings()
		_JPROFILER.pop("drawMenuSettings")
	elseif Gamestate == GamestateKeybindingMainSettings or Gamestate == GamestateKeybindingPlayingGameSettings then
		_JPROFILER.push("drawMenuSettings")
		DrawKeybindingSettings()
		_JPROFILER.pop("drawMenuSettings")
	end
	GamestateMainMenuDrawGame()
	GamestatePlayingGameDrawGame()
end
