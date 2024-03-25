function ReplaceChar(str, pos, r)
	return str:sub(1, pos - 1) .. r .. str:sub(pos + 1)
end

function UpdateVoxelData(self, blockvalue, x, y, z)
	self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))
	self.changes[#self.changes + 1] = { x, y, z }
end
function SetVoxelDataInternal(self, x, y, z, blockvalue, dataIndex)
	x, y, z = math.floor(x), math.floor(y), math.floor(z)
	if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
		local dataIndexOffset = (dataIndex == "First" and 2 or 3)
		self.voxels[x][z] =
			ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + dataIndexOffset, string.char(blockvalue))
		self.changes[#self.changes + 1] = { x, y, z }
	end
end

-- used for building structures across chunk borders
-- by requesting a block to be built in a chunk that does not yet exist
function NewChunkRequest(gx, gy, gz, valueg)
	_JPROFILER.push("NewChunkRequest")

	-- assume structures can only cross one chunk
	local lx, ly, lz = Localize(gx, gy, gz)
	local chunk = GetChunk(gx, gy, gz)

	if chunk ~= nil then
		chunk.requests[#chunk.requests + 1] = { x = lx, y = ly, z = lz, value = valueg }
	end
	_JPROFILER.pop("NewChunkRequest")
end

function InitSliceUpdates()
	for i = 1, WorldHeight / SliceHeight do
		SliceUpdates[i] = { false, false, false, false, false }
	end
	return SliceUpdates
end
function FindUpdatedSlices(self, sliceUpdates)
	_JPROFILER.push("findUpdatedSlices")
	local INDEX, NEG_X, POS_X, NEG_Z, POS_Z = 1, 2, 3, 4, 5
	for i = 1, #self.changes do
		local height = self.changes[i][2]
		local index = math.floor((height - 1) / SliceHeight) + 1
		if sliceUpdates[index] then
			sliceUpdates[index][INDEX] = true
			local floorHeight = math.floor(height / SliceHeight) + 1
			local ceilHeight = math.floor((height - 2) / SliceHeight) + 1
			if floorHeight > index and sliceUpdates[index + 1] then
				sliceUpdates[math.min(index + 1, #sliceUpdates)][INDEX] = true
			end
			if ceilHeight < index and sliceUpdates[index - 1] then
				sliceUpdates[math.max(index - 1, 1)][INDEX] = true
			end
			local xChange = self.changes[i][1]
			local zChange = self.changes[i][3]
			if xChange == 1 then
				sliceUpdates[index][NEG_X] = true
			elseif xChange == ChunkSize then
				sliceUpdates[index][POS_X] = true
			end
			if zChange == 1 then
				sliceUpdates[index][NEG_Z] = true
			elseif zChange == ChunkSize then
				sliceUpdates[index][POS_Z] = true
			end
		end
	end
	_JPROFILER.pop("findUpdatedSlices")
end
function UpdateFlaggedSlices(self, sliceUpdates)
	_JPROFILER.push("updateFlaggedSlices")
	for i = 1, WorldHeight / SliceHeight do
		if sliceUpdates[i][1] then
			if self.slices[i] then
				self.slices[i]:updateModel()
			end
		end
	end
	_JPROFILER.pop("updateFlaggedSlices")
end
function NewChunkSlice(x, y, z, parent)
	local t = NewThing(x, y, z)
	t.parent = parent
	local compmodel = Engine.newModel(nil, LightingTexture, { 0, 0, 0 })
	compmodel.culling = false
	t:assignModel(compmodel)
	t.isUpdating = false
	t.updateModel = function(chunk)
		if not chunk or not chunk.parent or not chunk.model then
			return
		end
		chunk.isUpdating = true
		SliceModels = {}
		for i = 1, ChunkSize do
			for j = chunk.y, chunk.y + SliceHeight - 1 do
				for k = 1, ChunkSize do
					local this, thisSunlight, thisLocalLight = chunk.parent:getVoxel(i, j, k)
					local Light = math.max(thisSunlight, thisLocalLight)
					local thisTransparency = TileTransparency(this)
					local x, y, z =
						(chunk.x - 1) * ChunkSize + i - 1, 1 * j * BlockModelScale, (chunk.z - 1) * ChunkSize + k - 1
					if thisTransparency < TilesTransparency.OPAQUE then
						if EnableTilesRenderingTestUnit == true then
							TileRenderingTestUnit(chunk, i, j, k, x, y, z, Light, SliceModels, BlockModelScale)
						else
							TileRendering(chunk, i, j, k, x, y, z, Light, SliceModels, BlockModelScale)
						end
						if EnableBlockRenderingTestUnit == true then
							BlockRenderingTestUnit(
								chunk,
								i,
								j,
								k,
								x,
								y,
								z,
								thisTransparency,
								Light,
								SliceModels,
								BlockModelScale
							)
						else
							BlockRendering(
								chunk,
								i,
								j,
								k,
								x,
								y,
								z,
								thisTransparency,
								Light,
								SliceModels,
								BlockModelScale
							)
						end

						--[[local data = {
							i,
							j,
							k,
							x,
							y,
							z,
							thisTransparency,
							Light,
							SliceModels,
							BlockModelScale,
							chunk.x,
							chunk.y,
							chunk.z,
						}
						BlockModellingChannel:push(data)]]
					end
				end
			end
		end
		if chunk.model then
			chunk.model:setVerts(SliceModels)
		end
		chunk.isUpdating = false
	end
	t.destroyModel = function(chunk)
		chunk.model.dead = true
	end
	return t
end
local function ApplySunlightEffect(
	gx,
	gy,
	gz,
	sunlight,
	manuallyPlaced,
	leftMouseDown,
	rightMouseDown,
	inDirectSunlight
)
	if inDirectSunlight then
		--Fix https://github.com/quentin452/LuaCraft/issues/53
		local addSunlight = leftMouseDown and rightMouseDown and sunlight
			or (rightMouseDown and LightSources[0] or (leftMouseDown and sunlight))
		if manuallyPlaced or addSunlight then
			NewLightOperation(gx, gy, gz, LightOpe.SunDownAdd.id, addSunlight)
			--ThreadLightingChannel:push({ "LightOperation", gx, gy, gz, LightOpe.SunDownAdd.id, addSunlight })
		end
	else
		-- Apply standard lighting for other cases
		for _, offset in ipairs(VoxelNeighborOffsets) do
			local dx, dy, dz = unpack(offset)
			NewLightOperation(gx + dx, gy + dy, gz + dz, LightOpe.SunCreationAdd.id)
			--ThreadLightingChannel:push({"LightOperation", gx + dx, gy + dy, gz + dz, LightOpe.SunCreationAdd.id})
		end
	end
end

local function HandleManuallyPlacedBlockTileLightableAdd(gx, gy, gz, manuallyPlaced, blockvalue)
	if manuallyPlaced then
		local source = TileLightSource(blockvalue)
		if source > 0 then
			NewLightOperation(gx, gy, gz, LightOpe.LocalAdd.id, source)
			--ThreadLightingChannel:push({ "LightOperation", gx, gy, gz, LightOpe.LocalAdd.id, source })
		else
			for _, offset in ipairs(VoxelNeighborOffsets) do
				local dx, dy, dz = unpack(offset)
				NewLightOperation(gx + dx, gy + dy, gz + dz, LightOpe.LocalCreationAdd.id)
				--ThreadLightingChannel:push({ "LightOperation", gx + dx, gy + dy, gz + dz, LightOpe.LocalCreationAdd.id })
			end
		end
	end
end

local function HandleSemiLightableBlocks(gx, gy, gz, manuallyPlaced, blockvalue, destroyLight, inDirectSunlight)
	-- Handle non-lightable blocks
	local semiLightable = TileLightable(blockvalue, true)
	if semiLightable and inDirectSunlight and manuallyPlaced then
		NewLightOperation(gx, gy + 1, gz, LightOpe.SunCreationAdd.id)
		--ThreadLightingChannel:push({ "LightOperation",gx, gy + 1, gz, LightOpe.SunCreationAdd.id })
	end
	if not semiLightable or manuallyPlaced then
		destroyLight = not TileLightable(blockvalue, true)
		for _, offset in ipairs(VoxelNeighborOffsets) do
			local dx, dy, dz = unpack(offset)
			local nx, ny, nz = gx + dx, gy + dy, gz + dz
			local nget = GetVoxelFirstData(nx, ny, nz)
			if nget < LightSources[15] then
				NewLightOperation(nx, ny, nz, LightOpe.SunSubtract.id, nget + LightSources[1])
				--ThreadLightingChannel:push({ "LightOperation",nx, ny, nz, LightOpe.SunSubtract.id,nget + LightSources[1] })
			end
		end
	end
	return destroyLight
end

local function HandleLightSourceBlock(self, gx, gy, gz, x, y, z, blockvalue, destroyLight)
	-- Handle light source blocks
	local source = TileLightSource(self:getVoxel(x, y, z))
	if source > 0 and TileLightSource(blockvalue) == Tiles.AIR_Block.id then
		NewLightOperation(gx, gy, gz, LightOpe.LocalSubtract.id, source + LightSources[1])
		--ThreadLightingChannel:push({"LightOperation",gx, gy, gz, LightOpe.LocalSubtract.id ,source + LightSources[1]})
		destroyLight = true
	end
	return destroyLight
end
local function HandleManuallyPlacedBlockTileLightableSub(gx, gy, gz, manuallyPlaced, destroyLight)
	if manuallyPlaced and destroyLight then
		for _, offset in ipairs(VoxelNeighborOffsets) do
			local dx, dy, dz = unpack(offset)
			local xd, yd, zd = gx + dx, gy + dy, gz + dz
			local nget = GetVoxelSecondData(xd, yd, zd)
			if nget < LightSources[15] then
				NewLightOperation(xd, yd, zd, LightOpe.LocalSubtract.id, nget + LightSources[1])
				--ThreadLightingChannel:push({"LightOperation", xd, yd, zd, LightOpe.LocalSubtract.id ,nget + LightSources[1]})
			end
		end
	end
end

local function HandleSunDownSubstract(gx, gy, gz)
	--Fix https://github.com/quentin452/LuaCraft/issues/66
	local voxel = GetVoxel(gx, gy, gz)
	if TileModel(voxel) == 0 then
		NewLightOperation(gx, gy, gz, LightOpe.SunDownSubtract.id)
		--ThreadLightingChannel:push({"LightOperation", gx, gy, gz, LightOpe.SunDownSubtract.id })
	end
	--Perform normal SunDown Subtract
	NewLightOperation(gx, gy - 1, gz, LightOpe.SunDownSubtract.id)
	--ThreadLightingChannel:push({"LightOperation", gx, gy - 1, gz, LightOpe.SunDownSubtract.id })
end

local placementRange1SpaceKeyOn = 1
local placementRange1SpaceKeyOff = 0.1
local function PreventBlockPlacementOnThePlayer(gx, gy, gz, leftMouseDown, rightMouseDown, spaceKey)
	local playerPos = getPlayerPosition()
	local playerXFloor, playerYFloor, playerZFloor = playerPos.x, playerPos.y, playerPos.z
	local range = spaceKey and placementRange1SpaceKeyOn or placementRange1SpaceKeyOff
	local minX, maxX = playerXFloor - range, playerXFloor + range
	local minY, maxY = playerYFloor, playerYFloor + 1
	local minZ, maxZ = playerZFloor - range, playerZFloor + range

	if gx >= minX and gx <= maxX and gy >= minY and gy <= maxY and gz >= minZ and gz <= maxZ then
		if rightMouseDown then
			return true
		elseif leftMouseDown then
			return Tiles.AIR_Block_id
		end
	end
	return false
end

local function PreventBlockPlacementOnCertainBlocksLikeFlower(self, x, y, z, blockvalue)
	local blockBelow = self:getVoxel(x, y - 1, z)
	local blockAbove = self:getVoxel(x, y + 1, z)
	if TileModel(blockvalue) == 1 and (TileModel(blockBelow) == 1 or TileModel(blockAbove) == 1) then
		return true
	end
	return false
end
function SetVoxelInternal(manuallyPlaced, self, x, y, z, blockvalue)
	manuallyPlaced = manuallyPlaced or false
	local leftMouseDown = love.mouse.isDown(1)
	local rightMouseDown = love.mouse.isDown(2)
	local spaceKey = love.keyboard.isDown("space")
	local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
	-- Check if coordinates are within chunk limits
	if IsWithinChunkLimits(x, y, z) then
		-- Check if block placement is prevented (e.g., on the player or certain blocks)
		if
			PreventBlockPlacementOnThePlayer(gx, gy, gz, leftMouseDown, rightMouseDown, spaceKey)
			or PreventBlockPlacementOnCertainBlocksLikeFlower(self, x, y, z, blockvalue)
		then
			return
		end
		local sunget = self:getVoxel(x, y + 1, z)
		local sunlight = self:getVoxelFirstData(x, y + 1, z)
		local inDirectSunlight = TileLightable(sunget) and sunlight == LightSources[15]
		local destroyLight = false

		if TileLightable(blockvalue) then
			ApplySunlightEffect(gx, gy, gz, sunlight, manuallyPlaced, leftMouseDown, rightMouseDown, inDirectSunlight)
			HandleManuallyPlacedBlockTileLightableAdd(gx, gy, gz, manuallyPlaced, blockvalue)
		else
			destroyLight =
				HandleSemiLightableBlocks(gx, gy, gz, manuallyPlaced, blockvalue, destroyLight, inDirectSunlight)
		end
		HandleSunDownSubstract(gx, gy, gz)
		HandleLightSourceBlock(self, gx, gy, gz, x, y, z, blockvalue, destroyLight)
		HandleManuallyPlacedBlockTileLightableSub(gx, gy, gz, manuallyPlaced, destroyLight)
		if blockvalue ~= -1 then
			UpdateVoxelData(self, blockvalue, x, y, z)
		end
	end
end

function IsWithinChunkLimits(x, y, z)
	return x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize
end
