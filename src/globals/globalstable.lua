--init shaders
-- Shader to change color of crosshair to contrast with what is being looked at
CrosshairShader = Lovegraphics.newShader(
	[[uniform Image source;uniform number xProportion;uniform number yProportion;vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){vec2 scaled_coords = (texture_coords - vec2(0.9375, 0)) * 16.0;vec4 sourcecolor = texture2D(source, vec2(0.5 + (-0.5 + scaled_coords.x) * xProportion, 0.5 + (0.5 - scaled_coords.y) * yProportion));sourcecolor.rgb = vec3(1.0) - sourcecolor.rgb;sourcecolor.a = texture2D(texture, texture_coords).a;return sourcecolor;}]]
)
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
TextureAtlasCoordinates = {}
TileCanvas = {}
ModLoaderTable = {}
ChunkSliceModels = {}
ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ThingList = {}
Engine = {}
ChunkVerts = {}
SliceUpdates = {}
TilesTextureFORAtlasList = {}
RenderChunks = {}
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
