font25 = lg.newFont(25)
font15 = lg.newFont(15)

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

	lg.setColor(unpack(currentColor))

	local i = 1
	local len = #Pstring

	while i <= len do
		local c = string.sub(Pstring, i, i)

		if c == "%" then
			local colorDigit = string.sub(Pstring, i + 1, i + 1)
			currentColor = colorMap[tostring(colorDigit)] or defaultColor
			lg.setColor(unpack(currentColor))
			i = i + 2 -- skip both '%' and the color digit
		else
			lg.print(c, rx, ry)
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
		lg.setFont(font25)
	end
	if gamestate == "WorldCreationMenu" or gamestate == "PlayingGame" then
		lg.setFont(font15)
	end
	_JPROFILER.pop("setFont")
end

function IsStructureIsGenerated(x, y, z)
	_JPROFILER.push("IsStructureIsGenerated")
	local blockKey = ("%d/%d/%d"):format(x, y, z)
	_JPROFILER.pop("IsStructureIsGenerated")
	return StructureMap[blockKey]
end

function isChunkFullyGenerated(scene, chunkX, chunkY, chunkZ)
	local chunkKey = ("%d/%d/%d"):format(chunkX, chunkY, chunkZ)
	local chunk = scene.chunkMap[chunkKey]

	if chunk and chunk.data then
		return true
	else
		return false
	end
end
