local texturepath = "resources/assets/textures/"
local blockandtilesfolder = "blocksandtiles/"
local blocktexturepath = blockandtilesfolder .. "/blocks/"
local liquidtexturepath = blockandtilesfolder .. "/liquid/"
local tilestexturepath = blockandtilesfolder .. "/tiles/"
function InitalizeTextureStatic()
	--TODO ADD MOD SUPPORT TILES CATEGORY
	LuaCraftTextures = {
		grassTopTexture = texturepath .. blocktexturepath .. "grass/grass_top.png",
		grassBottomTexture = texturepath .. blocktexturepath .. "grass/grass_bottom.png",
		grassSideTexture = texturepath .. blocktexturepath .. "grass/grass_side.png",
		airTexture = texturepath .. blocktexturepath .. "air.png",
		bedrockTexture = texturepath .. blocktexturepath .. "bedrock.png",
		coalTexture = texturepath .. blocktexturepath .. "coal.png",
		cobbleTexture = texturepath .. blocktexturepath .. "cobble.png",
		dirtTexture = texturepath .. blocktexturepath .. "dirt.png",
		glassTexture = texturepath .. blocktexturepath .. "glass.png",
		glowstoneTexture = texturepath .. blocktexturepath .. "glowstone.png",
		goldTexture = texturepath .. blocktexturepath .. "gold.png",
		gravelTexture = texturepath .. blocktexturepath .. "gravel.png",
		ironTexture = texturepath .. blocktexturepath .. "iron.png",
		oak_leavesTexture = texturepath .. blocktexturepath .. "oak_leaves.png",
		oak_logsTopTexture = texturepath .. blocktexturepath .. "oak_logs/oak_top.png",
		oak_logsBottomTexture = texturepath .. blocktexturepath .. "oak_logs/oak_botton.png",
		oak_logsSideTexture = texturepath .. blocktexturepath .. "oak_logs/oak_side.png",
		oak_planksTexture = texturepath .. blocktexturepath .. "oak_planks.png",
		sandTexture = texturepath .. blocktexturepath .. "sand.png",
		spongeTexture = texturepath .. blocktexturepath .. "sponge.png",
		stoneTexture = texturepath .. blocktexturepath .. "stone.png",
		stone_brickTexture = texturepath .. blocktexturepath .. "stone_brick.png",
		lavaTexture = texturepath .. liquidtexturepath .. "/lava.png",
		lavastationaryTexture = texturepath .. liquidtexturepath .. "lava_stationary.png",
		waterTexture = texturepath .. liquidtexturepath .. "water.png",
		waterstationaryTexture = texturepath .. liquidtexturepath .. "water_stationary.png",
		oak_sapplingsTexture = texturepath .. tilestexturepath .. "oak_sapplings.png",
		roseflowerTexture = texturepath .. tilestexturepath .. "rose_flower.png",
		yellowflowerTexture = texturepath .. tilestexturepath .. "yellow_flower.png",
	}
	--TODO ADD MOD SUPPORT TILES CATEGORY
	TilesTextureFORAtlasList = {
		[Tiles.STONE_Block.id] = { LuaCraftTextures.stoneTexture },
		[Tiles.GRASS_Block.id] = {
			LuaCraftTextures.grassTopTexture,
			LuaCraftTextures.grassBottomTexture,
			LuaCraftTextures.grassSideTexture,
		},
		[Tiles.DIRT_Block.id] = { LuaCraftTextures.dirtTexture },
		[Tiles.COBBLE_Block.id] = { LuaCraftTextures.cobbleTexture },
		[Tiles.OAK_PLANK_Block.id] = { LuaCraftTextures.oak_planksTexture },
		[Tiles.OAK_SAPPLING_Block.id] = { LuaCraftTextures.oak_sapplingsTexture },
		[Tiles.BEDROCK_Block.id] = { LuaCraftTextures.bedrockTexture },
		[Tiles.WATER_Block.id] = { LuaCraftTextures.waterTexture },
		[Tiles.STATIONARY_WATER_Block.id] = { LuaCraftTextures.waterstationaryTexture },
		[Tiles.LAVA_Block.id] = { LuaCraftTextures.lavaTexture },
		[Tiles.STATIONARY_LAVA_Block.id] = { LuaCraftTextures.lavastationaryTexture },
		[Tiles.SAND_Block.id] = { LuaCraftTextures.sandTexture },
		[Tiles.GRAVEL_Block.id] = { LuaCraftTextures.gravelTexture },
		[Tiles.GOLD_Block.id] = { LuaCraftTextures.goldTexture },
		[Tiles.IRON_Block.id] = { LuaCraftTextures.ironTexture },
		[Tiles.COAL_Block.id] = { LuaCraftTextures.coalTexture },
		[Tiles.OAK_LOG_Block.id] = {
			LuaCraftTextures.oak_logsTopTexture,
			LuaCraftTextures.oak_logsBottomTexture,
			LuaCraftTextures.oak_logsSideTexture,
		},
		[Tiles.OAK_LEAVE_Block.id] = { LuaCraftTextures.oak_leavesTexture },
		[Tiles.SPONGE_Block.id] = { LuaCraftTextures.spongeTexture },
		[Tiles.GLASS_Block.id] = { LuaCraftTextures.glassTexture },
		[Tiles.ROSE_FLOWER_Block.id] = { LuaCraftTextures.roseflowerTexture },
		[Tiles.YELLO_FLOWER_Block.id] = { LuaCraftTextures.yellowflowerTexture },
		[Tiles.STONE_BRICK_Block.id] = { LuaCraftTextures.stone_brickTexture },
		[Tiles.GLOWSTONE_Block.id] = { LuaCraftTextures.glowstoneTexture },
	}
	--TODO ADD MOD SUPPORT TILES CATEGORY
	TilesTextureFORAtlasListHUDPersonalized = {
		grassTopTexture = LuaCraftTextures.grassTopTexture,
		grassSideTexture = LuaCraftTextures.grassSideTexture,
		oak_logsTopTexture = LuaCraftTextures.oak_logsTopTexture,
		oak_logsSideTexture = LuaCraftTextures.oak_logsSideTexture,
	}
end
