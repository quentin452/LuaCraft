__AIR_Block = 0
__STONE_Block = 1
__GRASS_Block = 2
__DIRT_Block = 3
__COBBLE_Block = 4
__OAK_PLANK_Block = 5
__OAK_SAPPLING_Block = 6
__BEDROCK_Block = 7
__WATER_BLock = 8
__STATIONARY_WATER_BLock = 9
__LAVA_BLock = 10
__STATIONARY_LAVA_BLock = 11
__SAND_BLock = 12
__GRAVEL_BLock = 13
__GOLD_BLock = 14
__IRON_BLock = 15
__COAL_BLock = 16
__OAK_LOG_BLock = 17
__OAK_LEAVE_BLock = 18
__SPONGE_BLock = 19
__GLASS_BLock = 20
__YELLO_FLOWER_Block = 37
__ROSE_FLOWER_Block = 38
__STONE_BRICK_Block = 45
__GLOWSTONE_BLock = 89

__Light_Source0 = 0
__Light_Source11 = 1
__Light_Source12 = 2
__Light_Source13 = 3
__Light_Source14 = 4
__Light_Source15 = 5
__Light_Source16 = 6
__Light_Source17 = 7
__Light_Source18 = 8
__Light_Source19 = 9
__Light_Source10 = 10
__Light_Source11 = 11
__Light_Source12 = 12
__Light_Source13 = 13
__Light_Source14 = 14
__Light_Source15 = 15

-- tile enumerations stored as a function called by tile index (base 0 to accomodate air)
function TileCollisions(n)
	if
		n == __AIR_Block
		or n == __OAK_SAPPLING_Block
		or n == __WATER_BLock
		or n == __STATIONARY_WATER_BLock
		or n == __LAVA_BLock
		or n == __STATIONARY_LAVA_BLock
		or n == __YELLO_FLOWER_Block
		or n == __ROSE_FLOWER_Block
	then
		return false
	end

	return true
end

-- Define a lookup table for tile transparency values
local transparencyLookup = {
	[__AIR_Block] = 0, -- air
	[__YELLO_FLOWER_Block] = 0, -- yellow flower
	[__ROSE_FLOWER_Block] = 0, -- rose
	[__OAK_SAPPLING_Block] = 0, -- oaksappling
	[__OAK_LEAVE_BLock] = 1, -- oakleaves
	[__GLASS_BLock] = 2, -- glass
	[__GLOWSTONE_BLock] = 2, -- glowstone
}

local transparencyCache = {}

function TileTransparency(n)
	if transparencyCache[n] then
		return transparencyCache[n]
	else
		local transparency = transparencyLookup[n] or 3
		transparencyCache[n] = transparency
		return transparency
	end
end

function TileLightSource(n)
	--i think this should be optimized
	if n == __GLOWSTONE_BLock then -- glowstone
		return __Light_Source15
	end

	return __Light_Source0
end

function TileLightable(n)
	local t = TileTransparency(n)
	return t == 0 or t == 2
end

function TileSemiLightable(n)
	local t = TileTransparency(n)
	return t == 0 or t == 1 or t == 2
end

local tileTexturesCache = {}

function TileTextures(n)
	if tileTexturesCache[n] then
		return tileTexturesCache[n]
	end

	local list = {
		-- textures are in format: SIDE UP DOWN FRONT
		-- at least one texture must be present
		{ 0 }, -- 0 air
		{ 1 }, -- 1 stone
		{ 3, 0, 2 }, -- 2 grass
		{ 2 }, -- 3 dirt
		{ 16 }, -- 4 cobble
		{ 4 }, -- 5 planks
		{ 15 }, -- 6 sapling
		{ 17 }, -- 7 bedrock
		{ 14 }, -- 8 water
		{ 14 }, -- 9 stationary water
		{ 63 }, -- 10 lava
		{ 63 }, -- 11 stationary lava
		{ 18 }, -- 12 sand
		{ 19 }, -- 13 gravel
		{ 32 }, -- 14 gold
		{ 33 }, -- 15 iron
		{ 34 }, -- 16 coal
		{ 20, 21, 21 }, -- 17 log
		{ 52 }, -- 18 leaves
		{ 48 }, -- 19 sponge
		{ 49 }, -- 20 glass
	}
	list[38] = { 13 } -- 37 yellow flower
	list[39] = { 12 } -- 38 rose
	list[46] = { 7 } -- 18 leaves
	list[90] = { 105 } -- 89 glowstone

	tileTexturesCache[n] = list[n + 1]

	return tileTexturesCache[n]
end

function TileModel(n)
	-- flowers and mushrooms have different models
	if n == __YELLO_FLOWER_Block or n == __ROSE_FLOWER_Block or n == __OAK_SAPPLING_Block then
		return 1
	end

	return 0
end
function Tile2D(n)
	--draw in DrawHudTile 2D Tiles
	if n == __YELLO_FLOWER_Block or n == __ROSE_FLOWER_Block or n == __OAK_SAPPLING_Block then
		return true
	end

	return false
end