--init shaders
-- Shader to change color of crosshair to contrast with what is being looked at
CrosshairShader = love.graphics.newShader([[
    uniform Image source;
    uniform number xProportion;
    uniform number yProportion;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec2 scaled_coords;
        scaled_coords.x = (texture_coords.x - 0.9375) * 16;
        scaled_coords.y = texture_coords.y * 16;

        vec4 sourcecolor = Texel(source, vec2(0.5 + (-0.5 + scaled_coords.x) * xProportion, 0.5 + (0.5 - scaled_coords.y) * yProportion));
        sourcecolor.rgb = 1.0 - sourcecolor.rgb;

        vec4 crosshair = Texel(texture, texture_coords);
        sourcecolor.a = crosshair.a;

        return sourcecolor;
    }
]])
--init Menus tables
local function createMenu(x, y, title, choices)
	return {
		x = x,
		y = y,
		title = title,
		choice = choices,
		selection = 0, -- initialize to 0 to prevent unwanted object selection
	}
end

_GamePlayingPauseMenu = createMenu(50, 50, "Pause", {
	"UnPause",
	"Settings",
	"Exit to main menu",
})

_Mainmenu = createMenu(50, 50, "LuaCraft", {
	"%2World Creation Menu%0",
	"Settings",
	"Exit",
})

_MainMenuSettings = createMenu(50, 50, "Settings", {
	"Enable Vsync?",
	"Enable Logging (no warn or errors)?",
	"Enable warns logging?",
	"Enable errors logging?",
	"Render Distance",
	"Exiting to main menu",
})

_PlayingGameSettings = createMenu(50, 50, "Settings", {
	"Enable Vsync?",
	"Enable Logging (no warn or errors)?",
	"Enable warns logging?",
	"Enable errors logging?",
	"Render Distance",
	"Exiting to main menu",
})

_WorldCreationMenu = createMenu(50, 50, "World Creation Menu", {
	"Create World?",
	"Exiting to main menu",
})

--init global tables
TileTransparencyCache = {}
TileLightSourceCache = {}
TileCollisionCache = {}
TileModelCaching = {}
textureAtlasCoordinates = {}
TileCanvas = {}
ModLoaderTable = {}
ChunkSliceModels = {}
ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ThingList = {}
engine = {}
ChunkVerts = {}
TilesTextureFORAtlasList = {}
PlayerInventory = {
	items = {},
	hotbarSelect = 1,
}
TileMode = {
	BlockMode = "3DBlock",
	TileMode = "2DTile",
	LiquidMode = "3DLiquidBlock",
	None = "None",
}
CollideMode = {
	YesCanCollide = "YesCanCollide",
	NoCannotCollide = "NoCannotCollide",
}
TilesTransparency = {
	FULL = 0,
	PARTIAL = 1,
	NONE = 2,
	OPAQUE = 3,
}
LightSources = {}
for i = 0, 15 do
	LightSources[i] = i
end
Tiles = {
	AIR_Block = {
		id = 0,
		blockstringname = "AIR_Block",
		transparency = TilesTransparency.FULL,
		LightSources = LightSources[0],
		Cancollide = CollideMode.NoCannotCollide,
		BlockOrLiquidOrTile = TileMode.BlockMode,
	},
}

--init global variables
ChunkSize = 16
SliceHeight = 8
WorldHeight = 128
TileWidth, TileHeight = 1 / 16, 1 / 16
TileDataSize = 3
texturepathLuaCraft = "resources/assets/textures/"
blockandtilesfolderLuaCraft = "blocksandtiles"
blocktexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/blocks/"
liquidtexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/liquid/"
tilestexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/tiles/"
finalAtlasSize = 256 -- TODO ADD Support for atlas 4096 size and more
lovez = love
lovefilesystem = lovez.filesystem
lovegraphics = lovez.graphics
lovewindow = lovez.window
loveimage = lovez.image
lovetimer = lovez.timer
mathpi = math.pi
userDirectory = lovez.filesystem.getUserDirectory()
luacraftconfig = userDirectory .. ".LuaCraft\\luacraftconfig.txt"
globalVSync = lovewindow.getVSync()
font25 = lovegraphics.newFont(25)
font15 = lovegraphics.newFont(15)
BlockTest = lovegraphics.newImage(texturepathLuaCraft .. "debug/defaulttexture.png")
DefaultTexture = BlockTest
GuiSprites = lovegraphics.newImage(texturepathLuaCraft .. "guis/gui.png")
mainMenuBackground = lovegraphics.newImage("resources/assets/backgrounds/MainMenuBackground.png")
mainMenuSettingsBackground = lovegraphics.newImage("resources/assets/backgrounds/Mainmenusettingsbackground.png")
playingGamePauseMenu = lovegraphics.newImage("resources/assets/backgrounds/gameplayingpausemenu.png")
playingGameSettings = lovegraphics.newImage("resources/assets/backgrounds/playinggamesettings.png")
worldCreationBackground = lovegraphics.newImage("resources/assets/backgrounds/WorldCreationBackground.png")
ChunkBorders = lovegraphics.newImage(texturepathLuaCraft .. "debug/chunkborders.png")
LightValues = 16
GuiHotbarQuad = love.graphics.newQuad(0, 0, 182, 22, GuiSprites:getDimensions())
GuiHotbarSelectQuad = love.graphics.newQuad(0, 22, 24, 22 + 24, GuiSprites:getDimensions())
GuiCrosshair = love.graphics.newQuad(256 - 16, 0, 256, 16, GuiSprites:getDimensions())
LogicAccumulator = 0
PhysicsStep = true
cpml = require("libs/cpml")
--menus
require("src/menus/mainmenu")
require("src/menus/mainmenusettings")
require("src/menus/gameplayingpausemenu")
require("src/menus/playinggamesettings")
require("src/menus/worldcreationmenu")
--blocks
require("src/blocksandtiles/tiledata")
--utils
require("src/utils/things")
require("src/utils/math")
require("src/utils/mouseandkeybindlogic")
require("src/utils/usefull")
require("src/utils/filesystem")
require("src/utils/settingshandling")
require("src/utils/commands/commandsexec")
--entities
require("src/entities/player")
--world
Perspective = require("src/world/perspective")
require("src/world/lighting")
require("src/world/chunk")
require("src/world/updatelogic")
require("src/world/gen/generator")
require("src/world/gen/caves")
require("src/world/utilities/chunkmethods")
require("src/world/utilities/voxelsmethods")
--init
require("src/init/!init")
--client
require("src/client/huds/!draw")
require("src/client/blocks/blockrendering")
require("src/client/blocks/tilerendering")
require("src/client/textures/texturestatic")
--libs
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
--modloader
require("src/modloader/modloaderinit")
LoadBlocksAndTiles("src/blocksandtiles")
gamestateMainMenuSettings = "MainMenuSettings"
gamestateMainMenu = "MainMenu"
gamestatePlayingGame = "PlayingGame"
gamestatePlayingGameSettings = "PlayingGameSettings"
gamestateGamePausing = "GamePausing"
gamestateWorldCreationMenu = "WorldCreationMenu"
gamestate = gamestateMainMenu
enableF3 = false
enableF8 = false
enableTESTBLOCK = false
enableCommandHUD = false
fixinputforDrawCommandInput = false
renderdistancegetresetted = true
modelalreadycreated = 0
ChunkBorderAlreadyCreated = 0
hudTimeLeft = 0
Engine = require("engine")
