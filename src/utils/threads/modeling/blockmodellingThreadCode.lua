BlockModellingChannel, ChunkSize, ChunkHashTable, WorldHeight, TilesTextureList, TilesById, TileTransparencyCache, Tiles, TilesTransparency, BlockGetTop, BlockGetBottom, BlockGetPositiveX, BlockGetNegativeX, BlockGetPositiveZ, BlockGetNegativeZ, FinalAtlasSize, LightValues, TileWidth, TileHeight =
	...
local ADJUSTMENT_FACTOR_OTX_OTY = 256 / FinalAtlasSize
local ADJUSTMENT_FACTOR_TEXTURE_COORDINATES = FinalAtlasSize / 256
-- Shared block vertices
local blockVertices = {}

local function GetValueFromTilesById(n)
	return TilesById[n]
end

-- Checks if a face can be drawn based on transparency
local function TileTransparency(n)
	--if TileTransparencyCache[n] ~= nil then
	--	return TileTransparencyCache[n]
	--end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local transparency = Tiles[blockstringname].transparency
		--TileTransparencyCache[n] = transparency
		return transparency
	end
end

--[[local function TileTextures(n)
	print(n)
	return TilesTextureList[n]
end

local function GetTextureCoordinatesAndLight(texture, lightOffset)
	local textureIndex = texture
	local otx = ((textureIndex / ADJUSTMENT_FACTOR_TEXTURE_COORDINATES) % LightValues + 16 * lightOffset)
	local oty = math.floor(textureIndex / (ADJUSTMENT_FACTOR_TEXTURE_COORDINATES * LightValues))
	return otx, oty
end

local function Calculationotxoty(otx, oty)
	local tx = otx * TileWidth / LightValues
	local ty = oty * TileHeight
	local tx2 = (otx + ADJUSTMENT_FACTOR_OTX_OTY) * TileWidth / LightValues
	local ty2 = (oty + ADJUSTMENT_FACTOR_OTX_OTY) * TileHeight
	return tx, ty, tx2, ty2
end

-- Creates block vertices and adds them to the model
local function createBlockVertices(vertices, model)
	local totalVertices = #vertices
	local modelSize = #model
	for i = 1, totalVertices do
		model[modelSize + i] = vertices[i]
	end
end

-- Adds a face to the model based on direction and transparency
local function addFaceToModel(model, x, y, z, otx, oty, BlockModelScale, gettype)
	local tx, ty, tx2, ty2 = Calculationotxoty(otx, oty)
	local x_plus_scale = x + BlockModelScale
	local y_plus_scale = y + BlockModelScale
	local z_plus_scale = z + BlockModelScale
	if gettype == "getTop" or gettype == "getBottom" then
		blockVertices = {
			{ x, y, z, tx, ty },
			{ x_plus_scale, y, z, tx2, ty },
			{ x, y, z_plus_scale, tx, ty2 },
			{ x_plus_scale, y, z, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
			{ x, y, z_plus_scale, tx, ty2 },
		}
	elseif gettype == "getPositiveX" then
		blockVertices = {
			{ x, y_plus_scale, z, tx2, ty },
			{ x, y, z, tx2, ty2 },
			{ x, y, z_plus_scale, tx, ty2 },
			{ x, y_plus_scale, z_plus_scale, tx, ty },
			{ x, y_plus_scale, z, tx2, ty },
			{ x, y, z_plus_scale, tx, ty2 },
		}
	elseif gettype == "getNegativeX" then
		blockVertices = {
			{ x_plus_scale, y, z, tx, ty2 },
			{ x_plus_scale, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
			{ x_plus_scale, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y_plus_scale, z_plus_scale, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx2, ty2 },
		}
	elseif gettype == "getPositiveZ" then
		blockVertices = {
			{ x, y, z, tx, ty2 },
			{ x, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y, z, tx2, ty2 },
			{ x, y_plus_scale, z, tx, ty },
			{ x_plus_scale, y_plus_scale, z, tx2, ty },
			{ x_plus_scale, y, z, tx2, ty2 },
		}
	elseif gettype == "getNegativeZ" then
		blockVertices = {
			{ x, y_plus_scale, z_plus_scale, tx2, ty },
			{ x, y, z_plus_scale, tx2, ty2 },
			{ x_plus_scale, y, z_plus_scale, tx, ty2 },
			{ x_plus_scale, y_plus_scale, z_plus_scale, tx, ty },
			{ x, y_plus_scale, z_plus_scale, tx2, ty },
			{ x_plus_scale, y, z_plus_scale, tx, ty2 },
		}
	else
		ThreadLogChannel:push({ LuaCraftLoggingLevel.ERROR, "Invalid gettype: " .. gettype })
	end
	createBlockVertices(blockVertices, model)
end

-- Adds a face to the model based on direction and transparency
local function addFace(gettype, direction, y_offset, light_offset, thisLight, model, thisTransparency, scale, x, y, z)
	if CanDrawFace(direction, thisTransparency) then
		local textureIndex = math.min(2 + y_offset, #TileTextures(direction))
		local texture = (gettype == "getTop" or gettype == "getBottom") and TileTextures(direction)[textureIndex]
			or TileTextures(direction)[1]
		local otx, oty = GetTextureCoordinatesAndLight(texture, math.max(thisLight - light_offset, 0))
		addFaceToModel(model, x, y + y_offset * scale, z, otx, oty, scale, gettype)
	end
end

-- Draws faces of a block model
local function DrawFaces(
	model,
	thisTransparency,
	thisLight,
	BlockModelScale,
	x,
	y,
	z,
	BlockGetTop,
	BlockGetBottom,
	BlockGetPositiveX,
	BlockGetNegativeX,
	BlockGetPositiveZ,
	BlockGetNegativeZ
)
	addFace("getTop", BlockGetTop, 0, 0, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getBottom", BlockGetBottom, 1, 3, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveX", BlockGetPositiveX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeX", BlockGetNegativeX, 0, 2, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getPositiveZ", BlockGetPositiveZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
	addFace("getNegativeZ", BlockGetNegativeZ, 0, 1, thisLight, model, thisTransparency, BlockModelScale, x, y, z)
end]]

--[[while true do
	local data = BlockModellingChannel:demand()
	if data then
		local x = data.x
		local y = data.y
		local z = data.z
		local thisTransparency = data.thisTransparency
		local thisLight = data.thisLight
		local model = data.model
		local BlockModelScale = data.BlockModelScale

		-- Dessinez les faces en utilisant les données reçues
		DrawFaces(model, thisTransparency, thisLight, BlockModelScale, x, y, z)
	end
end
]]

--[[while true do
	local data = BlockModellingChannel:demand()
	if data then
		local x = data.x
		local y = data.y
		local z = data.z
		local thisTransparency = data.thisTransparency
		local thisLight = data.thisLight
		local model = data.model
		local BlockModelScale = data.BlockModelScale
		local BlockGetTop = data.BlockGetTop
		local BlockGetBottom = data.BlockGetBottom
		local BlockGetPositiveX = data.BlockGetPositiveX
		local BlockGetNegativeX = data.BlockGetNegativeX
		local BlockGetPositiveZ = data.BlockGetPositiveZ
		local BlockGetNegativeZ = data.BlockGetNegativeZ

		-- Dessinez les faces en utilisant les données reçues
		DrawFaces(
			model,
			thisTransparency,
			thisLight,
			BlockModelScale,
			x,
			y,
			z,
			BlockGetTop,
			BlockGetBottom,
			BlockGetPositiveX,
			BlockGetNegativeX,
			BlockGetPositiveZ,
			BlockGetNegativeZ
		)
	end
end
]]
local function CanDrawFace(get, thisTransparency)
	local tileTransparency = TileTransparency(get)
	local result = true
	if tileTransparency == TilesTransparency.FULL then
		result = false
	elseif tileTransparency == TilesTransparency.PARTIAL then
		result = true
	else
		result = tileTransparency ~= thisTransparency
	end
	return result
end

while true do
	local data = BlockModellingChannel:demand()
	if data then
	end
end
