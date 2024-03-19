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
				.. blockBottomMasterTexture
				.. " Side Texture: "
				.. blockSideTexture
				.. " Top Texture: "
				.. blockTopTexture
				.. "\n-----------------------------------------------------------------------------------------------------------------------",
		})
	end
end

local function updateTable(key, value)
	-- Envoi du message au thread séparé via le canal
	ChunkHashTableChannel:push({ key, value })
	print("Message envoyé au thread séparé:", key, value)
end

-- Fonction pour générer des valeurs aléatoires pour ChunkHashTableTesting
local function generateRandomValues()
	local randomKey = tostring(math.random(100)) -- Génération d'une clé aléatoire
	local randomValue = math.random(1000) -- Génération d'une valeur aléatoire
	updateTable(randomKey, randomValue) -- Mise à jour de la table dans le thread séparé
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
--	_JPROFILER.push("createChunkHashTableThread")
--	ChunkHashTableChannel = createChunkHashTableThread()
--	_JPROFILER.pop("createChunkHashTableThread")
--	for i = 1, 10 do
--		generateRandomValues()
--	end
	--TODO FIX BLOCK MODELLING THREAD
	--_JPROFILER.push("createBlockModellingThread")
	--BlockModellingChannel = createBlockModellingThread()
	--_JPROFILER.pop("createBlockModellingThread")
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
end
