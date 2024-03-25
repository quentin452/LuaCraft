
**LuaCraft V0.5**


This version is compatible with LOVE2D 11.5 and probably newer versions.

NEW FEATURES/IMPROVEMENTS:
    
    Rewrite GameStateHandling for maintainability
    Rewrite MenusHandling for really better performances
    Rewrite filesystem/settings
    Add Keybind Settings for Player Movements
    Add a warn if a generation is too much slow from by example the tag : chunkPopulateTag
    Add bedrock layer
    Add mouse support on menus 
    Add TestUnit Handling for Block Modelling + Chunk + Lightning + TileModel (not really test unit , just "benchmark" of performances)
    Optimize checkAndUpdateDefaults method from filesystem.lua
    Optimize Lightning Engine Code
    Optimize Cave Gen Code
    Optimize Chunk Code
    Optimize PreventBlockPlacementOnThePlayer
    Fix nil when toggling fullscreen
    Fix a critical bug that made EnableLuaCraftLoggingError + EnableLuaCraftLoggingWarn + EnableLuaCraftPrintLoggingNormal are nil at first game launch
    Fix correctly https://github.com/quentin452/LuaCraft/issues/31
    Fix correctly https://github.com/quentin452/LuaCraft/issues/9
    Fix https://github.com/quentin452/LuaCraft/issues/38
    Fix https://github.com/quentin452/LuaCraft/issues/49
    Fix https://github.com/quentin452/LuaCraft/issues/61
    Fix https://github.com/quentin452/LuaCraft/issues/64
    Fix https://github.com/quentin452/LuaCraft/issues/53
    Fix https://github.com/quentin452/LuaCraft/issues/66
    Fix https://github.com/quentin452/LuaCraft/issues/83
    Fix a potential bug in GenerateTerrain
    Fixed large lag caused by SunDownSubtract operation 
    Fix a mistake in DrawF3Tab 
    Fix some mistakes with Jprofiler code
    Fix Button size detection 
    Fix some bugs in the logic system of the player 
    Fix player Getter pos 
    Fixed MAJORITY OF THE lags caused by DrawColorString
    Fix a potential memory problem caused by CleanString from drawhud.lua  
    Code Refactor For Chunks + Lightning
    Remove texturestatic.lua (merge code into an another script) 
    Remove table.concat usage in loggers 
    Remove Table_HudTextureCache
    Remove a redundant LocalCreationAdd call in chunk.setVoxel
    Remove Salt Table usage
    Rename setVoxelRaw to setVoxelRawNotSupportLight  
    Reduce code redudancy in engine.lua for Verts
    Avoid nested loops in chunk.setVoxel 
    Avoid reasigning BlockAndTilesModelScale 
    Avoid unecessary GetVoxel check in caveCarve
    Avoid attempt to compare number with boolean caused by SunDownAdd
    Made a globale for WorldType 
    Made ReplaceChar "probably" more efficient 
    Made tiledata code more efficient 
    Reorganize global variables 
    Threading Testings
    Make A Thread for logging to avoid blocking main thread when logging alot of things
    Make A Thread for some TestUnits
    Disable texture atlas PNG creation to potentially reduce loading time 
    Call temp = {} at the end of GenerateTerrain instead of start to empty memory
    Memory Usage Improvments in some way
    Use Minetest resourcepack instead of the normal mc
    Use math.random instead of love.math.noise for Flower/Tree Generation
     Use Set from penlight for chunk.voxels it probably change nothing :D
    Simplify addBlock method 
    Reorganize huds/models scripts 
    Move IsWithinChunkLimits check into an auxiliary method 
    and more ....

**LuaCraft V0.4HOTFIX**

This version is compatible with LOVE2D 11.5 and probably newer versions.

HOTFIX

    Fix configs issues by mading this commit : https://github.com/quentin452/LuaCraft/commit/90eb96bbd7650099976d59ff6c189ff0ddb2fd2c , pls remove .LuaCraft folder in "C:\Users\yourusername\.LuaCraft" 

NEW FEATURES/IMPROVEMENTS:
    
    Continue to dedupplicate lighting codes 

**LuaCraft V0.4**

This version is compatible with LOVE2D 11.5 and probably newer versions.

NEW FEATURES/IMPROVEMENTS:

    Eeliminate potential lags caused by lightsource/transparency lookup
    add some debug (jprofiler) statements 
    Add detailled prints to know which block is initialized with which values
    Add ExampleMod_ prefix to scripts of ExampleMod 
    Start mod support for Tiles/Blocks
    Update ExmampleMod Instruction/doc
    Optimize rand method from math.lua
    Fix a synthax error in the script format of iron
    Improve general efficiency of block registration and maintainability
    Optimize atlas texture creation
    Update Texture handling to reduce calculation
    Extremly simplified texture handling (merge atlases) 
    Fix #31 (Sun lightning can pass through Glowstone)
    Fix ROSE_FLOWER_Block not spawning 
    Add some infos in F3 
    Rename some Table
    Fix mistakes in JPROF usage that causing crash while using it 
    Fix bugs in removeChunksOutsideRenderDistance 
    optimize blockrendering and updatelogic
    optimize images (compress)
    refactor Lightning code to reduce dupplications
    Optimize chunk.sunlight + choose from chunk.lua
    Abit optimize chunk.getVoxel + chunk.setVoxel from chunk.lua 
    fix #43 (diagonal chunks are removed)
    Reduce chunkslice update model frequency for performances 
    Reduce unecessary ChunkSet iteration in updalogic.lua that causing LARGE LAGS
    Make blockrendering.lua maintainable
    Dedupplicate player position getting + optimize spawn point
    Optimize GetSign and CopyTable from engine.lua
    Avoid creating at every calls vertices table for block models
    Update randomSeed logic
    Add utilities scripts 
    Reduce code dupplications in set/getvoxels methods 
    Readd transparencyCache
    Made some methods local from blockrendering.lua + lighting.lua + updatelogic.lua
    Fix a memory leak caused by GenerateTree
    Simplify ExampleMod.initialize populate code
    Refactor TileData code + readd some caches in it
    Add Documentations in blockrendering.lua + tiledata.lua + tilerendering.lua
    Greatly optimize DrawF3
    Move DrawTestBlock into an another script + disabling it
    Refactor drawhud.lua
    refactor Global Variables/tables 
    Optimize setFont
    Made all global using HigherCase
    Potential optimisation for createTileModel method?
    Fix a mistake that maked Test Block Model global instead of local
    Avoiding GetChunk repetition in LightningQueries from lighting.lua
    Made CrosshairShader compact to reduce byte usage
    Use elseif statements in checkAndUpdateDefaults filesystem.lua
    Made FFI a global variable
    Optimize LoadMods and LoadBlocksAndTiles
    Simplify UpdateChunks code
    Fix a mistake in chunk.processRequests that use a number parameter but the parameter needed is a boolean for the 5th parameter
    Avoid Redefined local in chunk.lua + lighting.lua
    Avoid unused local variable in lighting.lua

LIBRARIES REMOVED : 

    Remove PROFI and so code debugging in LuaCraft

REMOVED FEATURES:

    Remove some debug (jprofiler) statements 
    Remove OctaveNoise Cache
    Remove unecessary profilers in NewChunkSlice
    Remove chunk.updatemodel because its unnecessary in updatelogic.lua
    Remove uneccesary chunk.slices = {} + made methods local in updatelogic.lua
    Remove airTexture (unecessary)
    Remove isInTable in updatelogic.lua (causing lags)


**LuaCraft V0.3**
  
This version is compatible with LOVE2D 11.5, [11.5experiment1](https://github.com/quentin452/love-experiments/releases/tag/11.5experiment1), and probably newer versions.
The 11.5experiment1 version is not recommanded anymore , i customized love.run to remove love.timer.sleep that causing fps lags

NEW FEATURES/IMPROVEMENTS:

    Bugfixes, Performances, Logic improvments for Procedural generation/Render Distance
    Fix some issues with prevent block placements on player
    Fix player spawn location 
    Fix chunks are removed wrongly
    Improve block placement logic
    Optimize abit player.lua 
    Optimize a bit engine.lua  
    Update TileImplementation to increase performances
    Start optimize block/tile rendering/canvas/shaders 
    Make CavernGeneration/generator/chunk more performant
    Optimize engine.newModel
    Optimize lightning.lua by alot
    Switch from love.math.random() to math.random() (should improve by 40% performances of the random)
    Fix a lightning problem in Cavern by inverting by inverting UpdateCaves() and chunk:populate() call in updatelogic.lua
    Made return instead of Tiles.AIR_Block call if chunk.setVoxel is not correct to prevent bugs
    Rewrite Atlas texture to be dynamic and many small improvments
    Rewrite HUD RENDERING (FIXED LAGS/MEMORY USAGE/BOTTLENECKS CAUSED BY USAGE OF CANVAS ON HUD)
    Shading factor coherence for DrawHudTile
    Optimize assets usage
    avoid creating two times the crosshair render
    Customize love.run (don't need my love2d fork anymore)

REMOVED FEATURES:

    Remove "prevent manually diagonal block placements" (causing issues accross chunks borders)
    Remove VoxelCursor model (dead code)
    Remove some caches such has coordCache, tileTexturesCache, tileTexturesCacheHUD (unecessary caches)
    Remove structureinit (dead code)
    Remove dead codes in usefull.lua
    Remove unecessary list creation 
    Remove some infos in F3
    Remove unused png/obj


**LuaCraft V0.2**
  
This version is compatible with LOVE2D 11.5, [11.5experiment1](https://github.com/quentin452/love-experiments/releases/tag/11.5experiment1), and probably newer versions. We recommend using 11.5experiment1 for better performance.

NEW FEATURES/IMPROVEMENTS:

    [add Primary Creation World menu + dedup love.graphics.newFont](https://github.com/quentin452/LuaCraft/commit/1390633138c894a6d876f2b504d21631721a718b)
    https://github.com/quentin452/LuaCraft/issues/15
    https://github.com/quentin452/LuaCraft/issues/8
    for github : add github workflows : thx to Omay238
    [micro optimizations on love.graphics usage](https://github.com/quentin452/LuaCraft/commit/437ee090d742949b3bd223ab3f2a9b14b48518f2)
    [optimize usefull.lua functions](https://github.com/quentin452/LuaCraft/commit/75fce067037c53a4dc7dc37903e0a0b85fc0a1c0)
    Improve Gamestate handling
    Improve Tiles/Blocks handling
    Improve Generation
    Improve Chunk procedural gen/render distance
    Big code reorganizations
    Add DrawChunkBordersDEBUG + DrawTestBlock
    Optimize Tree generation
    add fullscreen support
    Add mods support(chunk.populate)
    Prevent some blocks like flower to be placed on an another flower
    Prevent diagonals block placements(manuallyplaced)
    Made Player Spawn location better
    Prevent Voxels/blocks placements on Player Model to prevent suffocation
    Add some huds
    Draw in 2D in HOTBAR Flowers/Sapplings tiles
    Improve Tile Rendering for flowers/sapplings by example
    Optimize Luacraftconfig.txt file reading performance
    Add /tp command
    and some other....

NEW LIBRARIES ADDED:

    New Voxel engine base

    lovecraft : https://github.com/groverburger/lovecraft

    cpml : https://github.com/quentin452/cpml

LIBRARIES REMOVED : 

    g3d : https://github.com/quentin452/g3d

    g3d_voxel : https://github.com/groverburger/g3d_voxel/tree/master/lib

NEW FIXES:

    https://github.com/quentin452/LuaCraft/issues/26
    https://github.com/quentin452/LuaCraft/issues/25
    https://github.com/quentin452/LuaCraft/issues/24
    https://github.com/quentin452/LuaCraft/issues/20
    https://github.com/quentin452/LuaCraft/issues/19
    https://github.com/quentin452/LuaCraft/issues/18
    https://github.com/quentin452/LuaCraft/issues/10
    https://github.com/quentin452/LuaCraft/issues/12
    Fix Vsync issues + some config issues
    Fix some filesystem issues
    Fix some logic issues
    Fix nil crashes in mouselogic.lua
    Fix logging bugs
    Fix collision issues with player jumping
    Fix can't profile some code points with JPROFILER
    and some other....

OTHER CHANGES:

    [Fix Typo + add Changelogs.md](https://github.com/quentin452/LuaCraft/commit/b31dd1fd9d96989910b6845fdc64199cf11bc6f9)
    Add some todos
    [Drastically improve performance for font](https://github.com/quentin452/LuaCraft/commit/b76bfb9fb640722ea7c6cda2d45385b61eb70fda)

REMOVED FEATURES:

    Structure generation because not compatible for now 

**LuaCraft V0.1 INITIAL RELEASE**

This version is compatible with LOVE2D 11.5, [11.5experiment1](https://github.com/quentin452/love-experiments/releases/tag/11.5experiment1), and probably newer versions. We recommend using 11.5experiment1 for better performance.

NEW FEATURES/IMPROVEMENTS:

    Added various menus.
    Introduced primary settings.
    Included an FPS counter in the game HUD.
    Dynamically resized background images based on the resolution.
    Optimized the G3D library.
    In GameScene:draw, now using chunk:draw() ensures that only chunks within the render distance are rendered, instead of randomly destroying chunks.
    Reduced redundant checks in GameScene:requestRemesh.

NEW LIBRARIES ADDED:

    G3D
    G3D Voxel Engine
    Jprof
    Profi

NEW FIXES:

    [Fixed the ability to see-through polygons](https://github.com/quentin452/LuaCraft/commit/246ac90935ce0223a10553cee8b58edd9ec72136) and various other issues.

OTHER CHANGES:

    Code formatted using Stylua.
    Added TODOs for Chunk Saving.

REMOVED FEATURES:

    None