font25 = love.graphics.newFont(25)
font15 = love.graphics.newFont(15)

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
			if
				gamestate == "MainMenu"
				or gamestate == "MainMenuSettings"
				or gamestate == "GamePausing"
				or gamestate == "PlayingGameSettings"
			then
				rx = rx + font25:getWidth(c)
			end
			if gamestate == "WorldCreationMenu" or gamestate == "PlayingGame" then
				rx = rx + font15:getWidth(c)
			end
			i = i + 1
		end
	end

	_JPROFILER.pop("drawColorString")
end

function setFont()
	_JPROFILER.push("setFont")
	if
		gamestate == "MainMenu"
		or gamestate == "MainMenuSettings"
		or gamestate == "GamePausing"
		or gamestate == "PlayingGameSettings"
	then
		love.graphics.setFont(font25)
	end
	if gamestate == "WorldCreationMenu" or gamestate == "PlayingGame" then
		love.graphics.setFont(font15)
	end
	_JPROFILER.pop("setFont")
end
