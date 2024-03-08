require("src/init/assetsinit")
require("src/init/canvasinit")
require("src/init/guisandhudinit")
require("src/init/shadersinit")
require("src/init/windowsettingsinit")
require("src/init/worldinit")

--modloader
require("src/modloader/modloaderinit")
function initWorldGenerationVariables()
	ChunkSize = 16
	SliceHeight = 8
	WorldHeight = 128
	TileWidth, TileHeight = 1 / 16, 1 / 16
	TileDataSize = 3
end

function InitializeGame()
	_JPROFILER.push("SettingsHandlingInit")
	SettingsHandlingInit()
	_JPROFILER.pop("SettingsHandlingInit")
	_JPROFILER.push("loadAndSaveLuaCraftFileSystem")
	loadAndSaveLuaCraftFileSystem()
	_JPROFILER.pop("loadAndSaveLuaCraftFileSystem")
	_JPROFILER.push("InitializeAssets")
	InitializeAssets()
	_JPROFILER.pop("InitializeAssets")
	_JPROFILER.push("LoadMods")
	LoadMods()
	_JPROFILER.pop("LoadMods")
	if
		EnableLuaCraftLoggingError == nil
		or EnableLuaCraftLoggingWarn == nil
		or EnableLuaCraftPrintLoggingNormalLogging == nil
	then
		--TODO FIX EnableLuaCraftLoggingError + EnableLuaCraftLoggingWarn + EnableLuaCraftPrintLoggingNormalLogging are nil at first game launch
		love.event.quit()
	end
	_JPROFILER.push("saveLogsToOldLogsFolder")
	saveLogsToOldLogsFolder()
	_JPROFILER.pop("saveLogsToOldLogsFolder")
	_JPROFILER.push("InitializeWindowSettings")
	InitializeWindowSettings()
	_JPROFILER.pop("InitializeWindowSettings")
	LogicAccumulator = 0
	PhysicsStep = true
	_JPROFILER.push("InitializeGuisAndHud")
	InitializeGuisAndHud()
	_JPROFILER.pop("InitializeGuisAndHud")
	_JPROFILER.push("InitializeShaders")
	InitializeShaders()
	_JPROFILER.pop("InitializeShaders")
	_JPROFILER.push("InitalizeLightningCanevas")
	InitializeGameTileCanvas()
	_JPROFILER.pop("InitalizeLightningCanevas")
	_JPROFILER.push("initWorldGenerationVariables")
	initWorldGenerationVariables()
	_JPROFILER.pop("initWorldGenerationVariables")
end
