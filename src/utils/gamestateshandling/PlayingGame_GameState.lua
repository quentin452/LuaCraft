--main.lua
function GamestatePlayingGameTextInput(text)
	if Gamestate == GamestatePlayingGame and EnableCommandHUD == true then
		CurrentCommand = CurrentCommand .. text
	end
end

function GamestatePlayingGameResize(w, h)
	if Gamestate == GamestatePlayingGame then
		local scaleX = w / GraphicsWidth
		local scaleY = h / GraphicsHeight
		Lovegraphics.scale(scaleX, scaleY)
		local newCanvas = Lovegraphics.newCanvas(w, h)

		Lovegraphics.setCanvas(newCanvas)
		Lovegraphics.draw(Scene.twoCanvas)
		Lovegraphics.setCanvas()

		Scene.twoCanvas = newCanvas
	end
end

function GamestatePlayingGameMouseMoved(x, y, dx, dy)
	-- forward mouselook to Scene object for first person camera control
	if Gamestate == GamestatePlayingGame then
		Scene:mouseLook(x, y, dx, dy)
	end
end

--!draw.lua
function GamestatePlayingGameDrawGame()
	if Gamestate == GamestatePlayingGame then
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
	end
end

--updatelogic.lua
function GamestatePlayingGameUpdateGame(dt)
	if Gamestate == GamestatePlayingGame then
		renderdistancevalue()
		PlayerInitIfNeeded()
		UpdateAndGenerateChunks(RenderDistance)
		UpdateLogic(dt)
	end
end