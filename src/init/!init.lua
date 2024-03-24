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
	--TODO MADE GET BLOCK /CHUNK THREAD FOR TESTINGS
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

	--TODO FIX LIGHTING THREAD
	--	_JPROFILER.push("createLightningThread")
	--	ThreadLightingChannel = createLightningThread()
	--	_JPROFILER.pop("createLightningThread")
	--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
	--	_JPROFILER.push("createChunkHashTableThread")
	--	ChunkHashTableChannel = createChunkHashTableThread()
	--	_JPROFILER.pop("createChunkHashTableThread")
	--TODO FIX BLOCK MODELLING THREAD
	--	_JPROFILER.push("createBlockModellingThread")
	--	BlockModellingChannel = createBlockModellingThread()
	--	_JPROFILER.pop("createBlockModellingThread")
end
