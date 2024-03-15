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
	elseif Gamestate == GamestatePlayingGame then
		_JPROFILER.push("DrawGameScene")
		-- draw 3d scene
		Scene:render(true)
		-- draw HUD
		Scene:renderFunction(function()
			DrawHudMain()
		end, false)
		love.graphics.setColor(1, 1, 1)
		DrawCanevas()
		_JPROFILER.pop("DrawGameScene")
	elseif Gamestate == GamestateMainMenuSettings then
		_JPROFILER.push("drawMainMenuSettings")
		drawMainMenuSettings()
		_JPROFILER.pop("drawMainMenuSettings")
	elseif Gamestate == GamestateMainMenu then
		_JPROFILER.push("drawMainMenu")
		drawMainMenu()
		_JPROFILER.pop("drawMainMenu")
	elseif Gamestate == GamestatePlayingGameSettings then
		_JPROFILER.push("drawPlayingMenuSettings")
		drawPlayingMenuSettings()
		_JPROFILER.pop("drawPlayingMenuSettings")
	end
end
