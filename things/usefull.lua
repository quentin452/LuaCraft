local colorMap = {
	["0"] = { 255, 255, 255 }, -- white
	["1"] = { 255, 0, 0 }, -- red
	["2"] = { 0, 255, 0 }, -- green
	["3"] = { 0, 255, 255 }, -- blue
}

function drawColorString(Pstring, Px, Py)
	_JPROFILER.push("drawColorString")
	local rx, ry = Px, Py
	local defaultColor = { 255, 255, 255 }
	local currentColor = defaultColor

	love.graphics.setColor(unpack(currentColor))

	local i = 1
	local len = #Pstring

	while i <= len do
		local c = string.sub(Pstring, i, i)

		if c == "%" then
			local colorDigit = string.sub(Pstring, i + 1, i + 1)
			currentColor = colorMap[tostring(colorDigit)] or defaultColor
			love.graphics.setColor(unpack(currentColor))
			i = i + 2 -- skip both '%' and the color digit
		else
			love.graphics.print(c, rx, ry)
			rx = rx + _font:getWidth(c)
			i = i + 1
		end
	end

	_JPROFILER.pop("drawColorString")
end

function setFont()
	_JPROFILER.push("setFont")
	if gamestate == "MainMenu" then
		_font = love.graphics.newFont(25)
	end
	if gamestate == "MainMenuSettings" then
		_font = love.graphics.newFont(25)
	end
	if gamestate == "WorldCreationMenu" then
		_font = love.graphics.newFont(15)
	end
	if gamestate == "PlayingGame" then
		_font = love.graphics.newFont(15)
	end
	if gamestate == "GamePausing" then
		_font = love.graphics.newFont(25)
	end
	if gamestate == "PlayingGameSettings" then
		_font = love.graphics.newFont(25)
	end
	love.graphics.setFont(_font)
	_JPROFILER.pop("setFont")
end
