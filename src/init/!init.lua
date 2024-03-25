require("src/init/assetsinit")
require("src/init/canvasinit")
require("src/init/windowsettingsinit")
require("src/init/worldinit")
require("src/init/modelloader")

function iterateOverAllTiles()
	for _, value in pairs(Tiles) do
		local blockTopTextureString = value.blockTopTextureString or "N/A"
		local blockSideTextureString = value.blockSideTextureString or "N/A"
		local blockBottomMasterTextureString = value.blockBottomMasterTextureString or "N/A"
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"Tile Name: "
				.. value.blockstringname
				.. " Index: "
				.. value.id
				.. " Transparency: "
				.. value.transparency
				.. " Light Source: "
				.. value.LightSources
				.. " Can Collide?: "
				.. value.Cancollide
				.. " Type: "
				.. value.BlockOrLiquidOrTile
				.. " BottomMaster Texture: "
				.. blockBottomMasterTextureString
				.. " Side Texture: "
				.. blockSideTextureString
				.. " Top Texture: "
				.. blockTopTextureString
				.. "\n-----------------------------------------------------------------------------------------------------------------------",
		})
	end
end
function InitializeGame()
	_JPROFILER.push("loadAndSaveLuaCraftFileSystem")
	loadAndSaveLuaCraftFileSystem()
	_JPROFILER.pop("loadAndSaveLuaCraftFileSystem")
	_JPROFILER.push("SettingsHandlingInit")
	SettingsHandlingInit()
	_JPROFILER.pop("SettingsHandlingInit")
	ThreadLogChannel = createLoggingThread()
	TestUnitThreadChannel = createTestUnitThread()
	_JPROFILER.push("ReLoadMovementKeyValues")
	ReLoadMovementKeyValues()
	_JPROFILER.pop("ReLoadMovementKeyValues")
	_JPROFILER.push("InitializeAssets")
	InitializeAssets()
	_JPROFILER.pop("InitializeAssets")
	_JPROFILER.push("LoadMods")
	LoadMods()
	_JPROFILER.pop("LoadMods")
	_JPROFILER.push("saveLogsToOldLogsFolder")
	saveLogsToOldLogsFolder()
	_JPROFILER.pop("saveLogsToOldLogsFolder")
	_JPROFILER.push("InitializeWindowSettings")
	InitializeWindowSettings()
	_JPROFILER.pop("InitializeWindowSettings")
	_JPROFILER.push("InitalizeLightningCanevas")
	InitializeGameTileCanvas()
	_JPROFILER.pop("InitalizeLightningCanevas")
	_JPROFILER.push("iterateOverAllTiles")
	iterateOverAllTiles()
	_JPROFILER.pop("iterateOverAllTiles")
end
