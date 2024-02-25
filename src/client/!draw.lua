require("src/client/drawhud")
function DrawGame()
	setFont()
	if gamestate == "GamePausing" then
		_JPROFILER.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		_JPROFILER.pop("drawGamePlayingPauseMenu")
	end
	if gamestate == "WorldCreationMenu" then
		_JPROFILER.push("drawWorldCreationMenu")
		drawWorldCreationMenu()
		_JPROFILER.pop("drawWorldCreationMenu")
	end
	if gamestate == "PlayingGame" then
		_JPROFILER.push("DrawGameScene")
		-- draw 3d scene
		Scene:render(true)

		-- draw HUD
		Scene:renderFunction(function()
			DrawF3()

			DrawCrossHair()

			love.graphics.setShader()

			DrawHotBar()

			for i = 1, 9 do
				DrawHudTile(PlayerInventory.items[i], InterfaceWidth / 2 - 182 + 40 * (i - 1), InterfaceHeight - 22 * 2)
			end
		end, false)

		love.graphics.setColor(1, 1, 1)
		DrawCanevas()
		_JPROFILER.pop("DrawGameScene")
	end

	if gamestate == "MainMenuSettings" then
		_JPROFILER.push("drawMainMenuSettings")
		drawMainMenuSettings()
		_JPROFILER.pop("drawMainMenuSettings")
	end

	if gamestate == "MainMenu" then
		_JPROFILER.push("drawMainMenu")
		drawMainMenu()
		_JPROFILER.pop("drawMainMenu")
	end

	if gamestate == "PlayingGameSettings" then
		_JPROFILER.push("drawPlayingMenuSettings")
		drawPlayingMenuSettings()
		_JPROFILER.pop("drawPlayingMenuSettings")
	end
end
