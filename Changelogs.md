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