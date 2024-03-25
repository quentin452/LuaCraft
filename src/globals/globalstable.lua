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
	"Chat/Command keybind",
	"Exiting to settings menu",
})

--init global tables
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
PlayerDirectionKey = {}
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
TilesById = { [0] = {
	blockstringname = "AIR_Block",
} }
LuaCraftLoggingLevel = {
	NORMAL = "NORMAL",
	WARNING = "WARN",
	ERROR = "FATAL",
}

LightOpe = {
	SunDownAdd = { id = "SunDownAdd" },
	SunForceAdd = { id = "SunForceAdd" },
	SunCreationAdd = { id = "SunCreationAdd" },
	SunAdd = { id = "SunAdd" },
	SunSubtract = { id = "SunSubtract" },
	SunDownSubtract = { id = "SunDownSubtract" },
	LocalAdd = { id = "LocalAdd" },
	LocalSubtract = { id = "LocalSubtract" },
	LocalForceAdd = { id = "LocalForceAdd" },
	LocalCreationAdd = { id = "LocalCreationAdd" },
}
VoxelNeighborOffsets = {}
for dx = -1, 1 do
	for dy = -1, 1 do
		for dz = -1, 1 do
			if dx ~= 0 or dy ~= 0 or dz ~= 0 then
				table.insert(VoxelNeighborOffsets, { dx, dy, dz })
			end
		end
	end
end
