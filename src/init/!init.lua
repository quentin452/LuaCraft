require("src/init/assetsinit")
require("src/init/canvasinit")
require("src/init/guisandhudinit")
require("src/init/shadersinit")
require("src/init/windowsettingsinit")
require("src/init/worldinit")
require("src/init/structureinit")

local function initWorldGenerationVariables()
	ChunkSize = 16
	SliceHeight = 8
	WorldHeight = 128
	TileWidth, TileHeight = 1 / 16, 1 / 16
	TileDataSize = 3
end

function InitializeGame()
	SettingsHandlingInit()
	loadAndSaveLuaCraftFileSystem()
	if
		EnableLuaCraftLoggingError == nil
		or EnableLuaCraftLoggingWarn == nil
		or EnableLuaCraftPrintLoggingNormalLogging == nil
	then
		--TODO FIX EnableLuaCraftLoggingError + EnableLuaCraftLoggingWarn + EnableLuaCraftPrintLoggingNormalLogging are nil at first game launch
		love.event.quit()
	end
	saveLogsToOldLogsFolder()
	ModLoaderInitALL()
	InitializeWindowSettings()
	StructureGenFinal()
	LogicAccumulator = 0
	PhysicsStep = true
	InitializeAssets()
	InitializeGuisAndHud()
	InitializeShaders()
	InitializeTileCanevas()
	InitalizeLightningCanevas()
	initWorldGenerationVariables()
end
