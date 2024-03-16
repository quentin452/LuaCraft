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

		LuaCraftPrintLoggingNormal(
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
				.. blockBottomMasterTexture
				.. " Side Texture: "
				.. blockSideTexture
				.. " Top Texture: "
				.. blockTopTexture
				.. "\n-----------------------------------------------------------------------------------------------------------------------"
		)
	end
end
function InitializeGame()
	_JPROFILER.push("SettingsHandlingInit")
	SettingsHandlingInit()
	_JPROFILER.pop("SettingsHandlingInit")
	_JPROFILER.push("loadAndSaveLuaCraftFileSystem")
	loadAndSaveLuaCraftFileSystem()
	_JPROFILER.pop("loadAndSaveLuaCraftFileSystem")
	_JPROFILER.push("loadMovementKeyValues")
	loadMovementKeyValues()
	_JPROFILER.pop("loadMovementKeyValues")
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
	_JPROFILER.push("InitalizeLightningCanevas")
	InitializeGameTileCanvas()
	_JPROFILER.pop("InitalizeLightningCanevas")
	_JPROFILER.push("iterateOverAllTiles")
	iterateOverAllTiles()
	_JPROFILER.pop("iterateOverAllTiles")
end
