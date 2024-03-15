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

	lovegraphics.setColor(currentColor)

	local i = 1
	local len = #Pstring

	while i <= len do
		local c = string.sub(Pstring, i, i)

		if c == "%" then
			local colorDigit = string.sub(Pstring, i + 1, i + 1)
			currentColor = colorMap[tostring(colorDigit)] or defaultColor
			lovegraphics.setColor(currentColor)
			i = i + 2 -- skip both '%' and the color digit
		else
			lovegraphics.print(c, rx, ry)
			local fontWidth = (
				gamestate == gamestateMainMenu
				or gamestate == gamestateMainMenuSettings
				or gamestate == gamestateGamePausing
				or gamestate == gamestatePlayingGameSettings
			)
					and font25
				or (gamestateWorldCreationMenu or gamestate == gamestatePlayingGame) and font15
			rx = rx + fontWidth:getWidth(c)
			i = i + 1
		end
	end
	lovegraphics.setColor(defaultColor)
	_JPROFILER.pop("drawColorString")
end

local fontTable = {
	MainMenu = font25,
	MainMenuSettings = font25,
	GamePausing = font25,
	PlayingGameSettings = font25,
	WorldCreationMenu = font15,
	PlayingGame = font15,
}

local previousGamestate = nil

function setFont()
	_JPROFILER.push("setFont")
	local selectedFont = fontTable[gamestate]
	if selectedFont and gamestate ~= previousGamestate then
		lovegraphics.setFont(selectedFont)
		previousGamestate = gamestate
	end
	_JPROFILER.pop("setFont")
end
