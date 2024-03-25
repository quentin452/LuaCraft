local marque = ""
local _GameStateTestUnitMenuSettings = CreateLuaCraftMenu(0, 0, "Test Unit Menu", {
	"Play a Test Unit",
	"Choose a Test Unit",
	"Exiting to main menu",
})
local MenuTable = _GameStateTestUnitMenuSettings
GameStateTestUnit = GameStateBase:new()
function GameStateTestUnit:resetMenuSelection()
	MenuTable.selection = 1
end

local TileDataWithCache = "TileDataWithCache"
local TileDataWithoutCache = "TileDataWithoutCache"
local LightningEngineTestUnit = "LightningEngineTestUnit"
local BlockModelingTestUnit = "BlockModelingTestUnit"
local TilesModelingTestUnit = "TilesModelingTestUnit"
local ChunkTestUnit = "ChunkTestUnit"
local UnitTest = TileDataWithCache

local TestUnitType = {
	[TileDataWithCache] = { name = "Tile Data With Cache", nextType = TileDataWithoutCache },
	[TileDataWithoutCache] = { name = "Tile Data Without Cache", nextType = LightningEngineTestUnit },
	[LightningEngineTestUnit] = { name = "Lightning Engine", nextType = BlockModelingTestUnit },
	[BlockModelingTestUnit] = { name = "Block Modeling", nextType = TilesModelingTestUnit },
	[TilesModelingTestUnit] = { name = "Tiles Modeling", nextType = ChunkTestUnit },
	[ChunkTestUnit] = { name = "Chunk", nextType = TileDataWithCache },
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
	DrawColorString(MenuTable.title, posX, posY)
	posY = posY + lineHeight
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		for n = 1, #MenuTable.choice do
			if EnableTestUnitWaitingScreen == true then
				DrawColorString("Wait Some Seconds and see logs...", posX, posY)
			elseif EnableTestUnitWaitingScreen == false then
				if MenuTable.selection == n then
					marque = "%1*%0 "
				else
					marque = "   "
				end
				local choiceText = MenuTable.choice[n]
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
	if EnableTestUnitWaitingScreen == false then
		if action == 1 then
			EnableTestUnitWaitingScreen = true
			if UnitTest == TileDataWithCache then
				TestUnitThreadChannel:push({ "TestUnitTileDataWithCache2" })
			elseif UnitTest == TileDataWithoutCache then
				TestUnitThreadChannel:push({ "TestUnitTileDataWithoutCache2" })
			elseif UnitTest == LightningEngineTestUnit then
				EnableLightningEngineDebug = true
			elseif UnitTest == BlockModelingTestUnit then
				EnableBlockRenderingTestUnit = true
			elseif UnitTest == TilesModelingTestUnit then
				EnableTilesRenderingTestUnit = true
			elseif UnitTest == ChunkTestUnit then
				EnableChunkTestUnit = true
			end
		elseif action == 2 then
			local unitType = TestUnitType[UnitTest]
			if unitType and unitType.nextType then
				UnitTest = unitType.nextType
			end
		end
		if
			action == 1
			and (
				UnitTest == LightningEngineTestUnit
				or UnitTest == BlockModelingTestUnit
				or UnitTest == TilesModelingTestUnit
				or UnitTest == ChunkTestUnit
			)
		then
			SetCurrentGameState(GameStatePlayingGame2)
			EnableTestUnitWaitingScreen = false
		elseif action == 3 then
			SetCurrentGameState(GamestateMainMenu2)
		end
	end
end

function GameStateTestUnit:resizeMenu()
	SharedSettingsResizeMenu(MenuTable.choice)
end
function GameStateTestUnit:mousepressed(x, y, b)
	SharedSelectionMenuBetweenGameState(x, y, b, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GameStateTestUnit:keypressed(k)
	MenuTable.choice, MenuTable.selection =
		SharedSelectionKeyPressedBetweenGameState(k, MenuTable.choice, MenuTable.selection, PerformMenuAction)
end
function GameStateTestUnit:setFont()
	return Font25
end
