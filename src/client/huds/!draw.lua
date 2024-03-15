require("src/client/huds/drawhud")
require("src/client/huds/tests/drawhudtest")
function DrawGame()
	setFont()
	if gamestate == gamestateGamePausing then
		_JPROFILER.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		_JPROFILER.pop("drawGamePlayingPauseMenu")
	end
	if gamestate == gamestateWorldCreationMenu then
		_JPROFILER.push("drawWorldCreationMenu")
		drawWorldCreationMenu()
		_JPROFILER.pop("drawWorldCreationMenu")
	end
	if gamestate == gamestatePlayingGame then
		_JPROFILER.push("DrawGameScene")
		-- draw 3d scene
		Scene:render(true)

		-- draw HUD
		Scene:renderFunction(function()
			DrawHudMain()
		end, false)

		lovegraphics.setColor(1, 1, 1)
		DrawCanevas()
		_JPROFILER.pop("DrawGameScene")
	end

	if gamestate == gamestateMainMenuSettings then
		_JPROFILER.push("drawMainMenuSettings")
		drawMainMenuSettings()
		_JPROFILER.pop("drawMainMenuSettings")
	end

	if gamestate == gamestateMainMenu then
		_JPROFILER.push("drawMainMenu")
		drawMainMenu()
		_JPROFILER.pop("drawMainMenu")
	end

	if gamestate == gamestatePlayingGameSettings then
		_JPROFILER.push("drawPlayingMenuSettings")
		drawPlayingMenuSettings()
		_JPROFILER.pop("drawPlayingMenuSettings")
	end
end
