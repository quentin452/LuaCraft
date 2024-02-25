function InitializeWindowSettings()
	-- window graphics settings
	GraphicsWidth, GraphicsHeight = 520 * 2, (520 * 9 / 16) * 2
	InterfaceWidth, InterfaceHeight = GraphicsWidth, GraphicsHeight
	love.graphics.setBackgroundColor(0, 0.7, 0.95)
	love.mouse.setRelativeMode(true)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	love.window.setTitle("LuaCraft")
end
