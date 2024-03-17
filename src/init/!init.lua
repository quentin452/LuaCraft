require("src/init/assetsinit")
require("src/init/canvasinit")
require("src/init/windowsettingsinit")
require("src/init/worldinit")
require("src/init/modelloader")

function iterateOverAllTiles()
	for _, value in pairs(Tiles) do
		local blockTopTexture = value.blockTopTexture or "N/A"
		local blockSideTexture = value.blockSideTexture or "N/A"
		local blockBottomMasterTexture = value.blockBottomMasterTexture or "N/A"

		ThreadLogChannel:push({ "NORMAL", "Tile Name: "
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
		.. blockBottomMasterTexture
		.. " Side Texture: "
		.. blockSideTexture
		.. " Top Texture: "
		.. blockTopTexture
		.. "\n-----------------------------------------------------------------------------------------------------------------------"
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
	_JPROFILER.push("createLoggingThread")
	ThreadLogChannel = createLoggingThread()
	_JPROFILER.pop("createLoggingThread")
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
