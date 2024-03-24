-- Renders a tile in the world
local vertices = {}
-- Creates a 2D tile model based on its ID, light level, and scale
local function createTileModel(tileID, thisLight, BlockModelScale)
	_JPROFILER.push("createTileModel")
	local startTime = os.clock()

	-- Retrieve texture and light coordinates for the tile
	local texture = TileTextures(tileID)[1]
	local otx, oty = GetTextureCoordinatesAndLight(texture, thisLight)
	local tx, ty, tx2, ty2 = Calculationotxoty(otx, oty)

	-- Define vertices for the 2D tile model
	local diagLong = 0.7071 * BlockModelScale * 0.5 + 0.5
	local diagShort = -0.7071 * BlockModelScale * 0.5 + 0.5

	vertices = {
		{ diagShort, 0, diagShort, tx2, ty2 },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagShort, BlockModelScale, diagShort, tx2, ty },
		{ diagLong, 0, diagLong, tx, ty2 },
		{ diagLong, BlockModelScale, diagLong, tx, ty },
		{ diagShort, BlockModelScale, diagShort, tx2, ty },
	}
	local endTime = os.clock()
	TilesModellingTestUnitTimer = TilesModellingTestUnitTimer + 1
	if TilesModellingTestUnitTimer <= 10000 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"createTileModel Execution Time: " .. tostring(endTime - startTime),
		})
	end
	_JPROFILER.pop("createTileModel")
	return vertices
end

function TileRenderingTestUnit(chunk, i, j, k, x, y, z, thisLight, model, BlockModelScale)
	_JPROFILER.push("TileRendering")
	local startTime = os.clock()

	-- Retrieve the tile ID at the given position
	local this = chunk.parent:getVoxel(i, j, k)

	-- Check if the tile has a 2D model
	if TileModel(this) == 1 then
		-- Check if the tile model data is cached
		local tileModelData = TileModelCaching[this]
		if not tileModelData then
			-- Create and cache the tile model data if not already cached
			tileModelData = createTileModel(this, thisLight, BlockModelScale)
			TileModelCaching[this] = tileModelData
		end

		-- Add the tile model vertices to the model list
		for _, v in ipairs(tileModelData) do
			model[#model + 1] = { x + v[1], y + v[2], z + v[3], v[4], v[5] }
		end

		-- Add rotated tile model vertices to the model list
		for _, v in ipairs(tileModelData) do
			local originX = v[1] - 0.5
			local originZ = v[3] - 0.5

			local rotatedX = originX * math.cos(math.pi / 2) - originZ * math.sin(math.pi / 2)
			local rotatedZ = originX * math.sin(math.pi / 2) + originZ * math.cos(math.pi / 2)

			rotatedX = rotatedX + 0.5
			rotatedZ = rotatedZ + 0.5

			model[#model + 1] = { x + rotatedX, y + v[2], z + rotatedZ, v[4], v[5] }
		end
	end
	local endTime = os.clock()
	if TilesModellingTestUnitTimer <= 10000 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"TileRenderingTestUnit Execution Time: " .. tostring(endTime - startTime),
		})
	end
	_JPROFILER.pop("TileRendering")
end
