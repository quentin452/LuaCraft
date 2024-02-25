require("src/client/drawhud")
function DrawGame()
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
end
