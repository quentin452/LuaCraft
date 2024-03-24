local Settings = {}
local orderedKeys = { "forwardmovementkey", "backwardmovementkey", "leftmovementkey", "rightmovementkey" }
local marque = ""
local _GameStateTestUnitMenuSettings = CreateLuaCraftMenu(0, 0, "Test Unit Menu", {
	"Play a Test Unit",
	"Choose a Test Unit",
	"Exiting to main menu",
})

GameStateTestUnit = GameStateBase:new()
function GameStateTestUnit:resetMenuSelection()
	_GameStateTestUnitMenuSettings.selection = 1
end

local TileDataWithCache = "TileDataWithCache"
local TileDataWithoutCache = "TileDataWithoutCache"
local UnitTest = TileDataWithCache

local TestUnitType = {
	[TileDataWithCache] = { name = "Tile Data With Cache", nextType = TileDataWithoutCache },
	[TileDataWithoutCache] = { name = "Tile Data Without Cache", nextType = TileDataWithCache },
}

function GameStateTestUnit:draw()
	_JPROFILER.push("drawMenuSettings")
	local w, h = Lovegraphics.getDimensions()
	local scaleX = w / TestUnitBackground:getWidth()
	local scaleY = h / TestUnitBackground:getHeight()
	Lovegraphics.draw(TestUnitBackground, 0, 0, 0, scaleX, scaleY)
	local posX = w * 0.4
	local posY = h * 0.4
	local lineHeight = GetSelectedFont():getHeight("X")
	DrawColorString(_GameStateTestUnitMenuSettings.title, posX, posY)
	posY = posY + lineHeight
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		for _, key in ipairs(orderedKeys) do
			local value = file_content:match(key .. "=(%w+)")
			if value then
				Settings[key] = value
			end
		end
		for n = 1, #_GameStateTestUnitMenuSettings.choice do
			if _GameStateTestUnitMenuSettings.selection == n then
				marque = "%1*%0 "
			else
				marque = "   "
			end
			local choiceText = _GameStateTestUnitMenuSettings.choice[n]
			if n == 2 then
				local testUnit = TestUnitType[UnitTest]
				local testUnitName = testUnit.name
				DrawColorString(marque .. choiceText .. " (" .. testUnitName .. ")", posX, posY)
			else
				DrawColorString(marque .. "" .. choiceText, posX, posY)
			end
			DrawColorString(marque .. "" .. choiceText, posX, posY)
			posY = posY + lineHeight
		end
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Failed to read Luacraftconfig.txt. Error: " .. error_message,
		})
	end
	_JPROFILER.pop("drawMenuSettings")
end

local function PerformMenuAction(action)
	if action == 1 then
		if UnitTest == TileDataWithCache then
			TestUnitTileDataWithCache2()
		elseif UnitTest == TileDataWithoutCache then
			TestUnitTileDataWithoutCache2()
		end
	elseif action == 2 then
		local unitType = TestUnitType[UnitTest]
		if unitType and unitType.nextType then
			UnitTest = unitType.nextType
		end
	elseif action == 3 then
		SetCurrentGameState(GamestateMainMenu2)
	end
end
function GameStateTestUnit:mousepressed(x, y, b)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = GetSelectedFont():getHeight("X")
		local menuWidth = 0
		for _, choice in ipairs(_GameStateTestUnitMenuSettings.choice) do
			local choiceWidth = GetSelectedFont():getWidth(choice)
			if choiceWidth > menuWidth then
				menuWidth = choiceWidth
			end
		end
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if
			choiceClicked >= 1
			and choiceClicked <= #_GameStateTestUnitMenuSettings.choice
			and x >= minX
			and x <= maxX
		then
			_GameStateTestUnitMenuSettings.selection = choiceClicked
			PerformMenuAction(choiceClicked)
		end
	end
end

function GameStateTestUnit:keypressed(k)
	if k == BackWardKey and ConfiguringMovementKey == false then
		if _GameStateTestUnitMenuSettings.selection < #_GameStateTestUnitMenuSettings.choice then
			_GameStateTestUnitMenuSettings.selection = _GameStateTestUnitMenuSettings.selection + 1
		end
	elseif k == ForWardKey and ConfiguringMovementKey == false then
		if _GameStateTestUnitMenuSettings.selection > 1 then
			_GameStateTestUnitMenuSettings.selection = _GameStateTestUnitMenuSettings.selection - 1
		end
	elseif k == "return" then
		PerformMenuAction(_GameStateTestUnitMenuSettings.selection)
	end
end

function GameStateTestUnit:setFont()
	return Font25
end
