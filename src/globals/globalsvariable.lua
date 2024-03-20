-- Initialisation des variables globales

-- Constants
ChunkSize = 16
SliceHeight = 8
WorldHeight = 128
TileWidth, TileHeight = 1 / 16, 1 / 16
TileDataSize = 3
FinalAtlasSize = 256 -- TODO ADD Support for atlas 4096 size and more
LightValues = 16
GlobalRenderDistance = 2
BlockModelScale = 1

-- Resource paths
TexturepathLuaCraft = "resources/assets/textures/"
BlockandtilesfolderLuaCraft = "blocksandtiles"
BlockTexturepathLuaCraft = BlockandtilesfolderLuaCraft .. "/blocks/"
LiquidTexturepathLuaCraft = BlockandtilesfolderLuaCraft .. "/liquid/"
TilesTexturepathLuaCraft = BlockandtilesfolderLuaCraft .. "/tiles/"
MainMenuBackgroundPath = "resources/assets/backgrounds/MainMenuBackground.png"
MainMenuSettingsBackgroundPath = "resources/assets/backgrounds/Mainmenusettingsbackground.png"
KeybindingSettingsBackgroundPath = "resources/assets/backgrounds/KeyBindingSettingsBackground.png"
PlayingGamePauseMenuPath = "resources/assets/backgrounds/gameplayingpausemenu.png"
WorldCreationBackgroundPath = "resources/assets/backgrounds/WorldCreationBackground.png"
BlockTest = Lovegraphics.newImage(TexturepathLuaCraft .. "debug/defaulttexture.png")
GuiSprites = Lovegraphics.newImage(TexturepathLuaCraft .. "guis/gui.png")
DefaultTexture = BlockTest
ChunkBorders = Lovegraphics.newImage(TexturepathLuaCraft .. "debug/chunkborders.png")

-- File paths
UserDirectory = Lovefilesystem.getUserDirectory()
Luacraftconfig = UserDirectory .. ".LuaCraft\\Luacraftconfig.txt"
LogFilePath = UserDirectory .. "\\.LuaCraft\\Luacraft.log"
LuaCraftDirectory = UserDirectory .. ".LuaCraft\\"

-- another variables
Mathpi = math.pi
GlobalVSync = Lovewindow.getVSync()
Font25 = Lovegraphics.newFont(25)
Font15 = Lovegraphics.newFont(15)
MainMenuBackground = Lovegraphics.newImage(MainMenuBackgroundPath)
MainMenuSettingsBackground = Lovegraphics.newImage(MainMenuSettingsBackgroundPath)
KeybindingSettingsBackground = Lovegraphics.newImage(KeybindingSettingsBackgroundPath)
PlayingGamePauseMenu = Lovegraphics.newImage(PlayingGamePauseMenuPath)
WorldCreationBackground = Lovegraphics.newImage(WorldCreationBackgroundPath)
GuiHotbarQuad = Lovegraphics.newQuad(0, 0, 182, 22, GuiSprites:getDimensions())
GuiHotbarSelectQuad = Lovegraphics.newQuad(0, 22, 24, 22 + 24, GuiSprites:getDimensions())
GuiCrosshair = Lovegraphics.newQuad(256 - 16, 0, 256, 16, GuiSprites:getDimensions())
CurrentCommand = ""
LuaCraftCurrentGameState = nil
Modelalreadycreated = 0
ChunkBorderAlreadyCreated = 0
HudTimeLeft = 0
LogicAccumulator = 0
Renderdistancegetresetted = true
ResetMovementKeys = true
ResetLoggerKeys = true
PhysicsStep = true
EnableF3 = false
EnableF8 = false
EnableTESTBLOCK = false
EnableCommandHUD = false
FixinputforDrawCommandInput = false
ConfiguringMovementKey = false
WorldSuccessfullyLoaded = false
HudMessage = nil
BlockGetTop = nil
BlockGetBottom = nil
BlockGetPositiveX = nil
BlockGetNegativeX = nil
BlockGetPositiveZ = nil
BlockGetNegativeZ = nil
--Keybinds
ForWardKey = nil
BackWardKey = nil
LeftKey = nil
RightKey = nil
