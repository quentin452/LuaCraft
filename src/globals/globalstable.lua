--init shaders
-- Shader to change color of crosshair to contrast with what is being looked at
CrosshairShader = Lovegraphics.newShader(
	[[uniform Image source;uniform number xProportion;uniform number yProportion;vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){vec2 scaled_coords = (texture_coords - vec2(0.9375, 0)) * 16.0;vec4 sourcecolor = texture2D(source, vec2(0.5 + (-0.5 + scaled_coords.x) * xProportion, 0.5 + (0.5 - scaled_coords.y) * yProportion));sourcecolor.rgb = vec3(1.0) - sourcecolor.rgb;sourcecolor.a = texture2D(texture, texture_coords).a;return sourcecolor;}]]
)
--init Menus tables
_MainMenuSettings = CreateLuaCraftMenu(0, 0, "Settings", {
	"Enable Vsync?",
	"Enable Logging (no warn or errors)?",
	"Enable warns logging?",
	"Enable errors logging?",
	"Render Distance",
	"Keybinding Settings Menu",
	"Exiting to main menu",
})
_KeybindingMenuSettings = CreateLuaCraftMenu(0, 0, "Keybinding Settings", {
	"Forward keybind",
	"Backward keybind",
	"Left keybind",
	"Right keybind",
	"Exiting to settings menu",
})

--init global tables
TileTransparencyCache = {}
TileLightSourceCache = {}
TileCollisionCache = {}
TileModelCaching = {}
TextureAtlasCoordinates = {}
TileCanvas = {}
ModLoaderTable = {}
SliceModels = {}
ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ThingList = {}
Engine = {}
ChunkVerts = {}
SliceUpdates = {}
TilesTextureFORAtlasList = {}
RenderChunks = {}
LightingQueue = {}
LightingRemovalQueue = {}
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
LuaCraftLoggingLevel = {
	NORMAL = "NORMAL",
	WARNING = "WARN",
	ERROR = "FATAL",
}

-- Function to add an item to the lighting queue
local function LightingQueueAdd(lthing)
	LightingQueue[#LightingQueue + 1] = lthing
	return lthing
end

-- Function to add an item to the lighting removal queue
local function LightingRemovalQueueAdd(lthing)
	LightingRemovalQueue[#LightingRemovalQueue + 1] = lthing
	return lthing
end
LightOpe = {
	SunDownAdd = { id = "SunDownAdd", lightope = LightingQueueAdd },
	SunForceAdd = { id = "SunForceAdd", lightope = LightingQueueAdd },
	SunCreationAdd = { id = "SunCreationAdd", lightope = LightingQueueAdd },
	SunAdd = { id = "SunAdd", lightope = LightingQueueAdd },
	SunSubtract = { id = "SunSubtract", lightope = LightingRemovalQueueAdd },
	SunDownSubtract = { id = "SunDownSubtract", lightope = LightingRemovalQueueAdd },
	LocalAdd = { id = "LocalAdd", lightope = LightingQueueAdd },
	LocalSubtract = { id = "LocalSubtract", lightope = LightingRemovalQueueAdd },
	LocalForceAdd = { id = "LocalForceAdd", lightope = LightingQueueAdd },
	LocalCreationAdd = { id = "LocalCreationAdd", lightope = LightingQueueAdd },
}
