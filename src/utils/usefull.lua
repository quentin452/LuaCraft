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

	Lovegraphics.setColor(currentColor)

	local i = 1
	local len = #Pstring

	while i <= len do
		local c = string.sub(Pstring, i, i)

		if c == "%" then
			local colorDigit = string.sub(Pstring, i + 1, i + 1)
			currentColor = colorMap[tostring(colorDigit)] or defaultColor
			Lovegraphics.setColor(currentColor)
			i = i + 2 -- skip both '%' and the color digit
		else
			Lovegraphics.print(c, rx, ry)
			local fontWidth = (
				Gamestate == GamestateMainMenu
				or Gamestate == GamestateMainMenuSettings
				or Gamestate == GamestateGamePausing
				or Gamestate == GamestatePlayingGameSettings
			)
					and Font25
				or (GamestateWorldCreationMenu or Gamestate == GamestatePlayingGame) and Font15
			rx = rx + fontWidth:getWidth(c)
			i = i + 1
		end
	end
	Lovegraphics.setColor(defaultColor)
	_JPROFILER.pop("drawColorString")
end

local fontTable = {
	MainMenu = Font25,
	MainMenuSettings = Font25,
	GamePausing = Font25,
	PlayingGameSettings = Font25,
	WorldCreationMenu = Font15,
	PlayingGame = Font15,
}

local previousGamestate = nil

function setFont()
	_JPROFILER.push("setFont")
	local selectedFont = fontTable[Gamestate]
	if selectedFont and Gamestate ~= previousGamestate then
		Lovegraphics.setFont(selectedFont)
		previousGamestate = Gamestate
	end
	_JPROFILER.pop("setFont")
end
