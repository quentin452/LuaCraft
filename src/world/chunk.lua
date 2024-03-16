function ReplaceChar(str, pos, r)
	return str:sub(1, pos - 1) .. r .. str:sub(pos + #r)
end

function NewChunk(x, z)
	_JPROFILER.push("NewChunk")

	local chunk = NewThing(x, 0, z)
	chunk.voxels = {}
	chunk.slices = {}
	chunk.heightMap = {}
	chunk.name = "chunk"

	chunk.ceiling = 120
	chunk.floor = 48
	chunk.requests = {}

	-- store a list of voxels to be updated on next modelUpdate
	chunk.changes = {}
	chunk.updatedSunLight = false
	chunk.isPopulated = false
	chunk.updateLighting = false

	for i = 1, ChunkSize do
		chunk.heightMap[i] = {}
	end
	GenerateTerrain(chunk, x, z, StandardTerrain)

	local gx, gz = (chunk.x - 1) * ChunkSize + rand(0, 15), (chunk.z - 1) * ChunkSize + rand(0, 15)

	if choose({ true, false }) then
		--_JPROFILER.push("chooseCave")

		local caveConfigs = {
			{ minHeight = 8, maxHeight = 64, count = rand(1, 3) },
			{ minHeight = 48, maxHeight = 80, count = rand(1, 2) },
		}

		for _, config in ipairs(caveConfigs) do
			for i = 1, config.count do
				NewCave(gx, rand(config.minHeight, config.maxHeight), gz)
			end
		end

		--_JPROFILER.pop("chooseCave")
	end

	chunk.sunlight = function(self)
		for i = 1, ChunkSize do
			for j = 1, ChunkSize do
				local gridX, gridZ = (self.x - 1) * ChunkSize + i - 1, (self.z - 1) * ChunkSize + j - 1
				if self.heightMap[i] and self.heightMap[i][j] then
					local this = self.heightMap[i][j]
					if i == 1 or this > (self.heightMap[i - 1] and self.heightMap[i - 1][j] or 0) + 1 then
						NewLightOperation(gridX - 1, this, gridZ, "NewSunlightDownAddition", LightSources[15])
					end
					if j == 1 or this > self.heightMap[i][j - 1] then
						NewLightOperation(gridX, this, gridZ - 1, "NewSunlightDownAddition", LightSources[15])
					end
					if i == ChunkSize or this > self.heightMap[i + 1][j] then
						NewLightOperation(gridX + 1, this, gridZ, "NewSunlightDownAddition", LightSources[15])
					end
					if j == ChunkSize or this > self.heightMap[i][j + 1] then
						NewLightOperation(gridX, this, gridZ + 1, "NewSunlightDownAddition", LightSources[15])
					end
				end
			end
		end
	end

	chunk.processRequests = function(self)
		--_JPROFILER.push("processRequests")

		for j = 1, #self.requests do
			local block = self.requests[j]
			if not TileCollisions(self:getVoxel(block.x, block.y, block.z)) then
				self:setVoxel(block.x, block.y, block.z, block.value, false)
			end
		end
		--_JPROFILER.pop("processRequests")
	end

	-- populate chunk with trees and flowers
	chunk.populate = function(self)
		--_JPROFILER.push("populate")

		for i = 1, ChunkSize do
			local heightMap_i = self.heightMap[i]
			if heightMap_i then
				for j = 1, ChunkSize do
					local height = heightMap_i[j]
					if height and TileCollisions(self:getVoxel(i, height, j)) then
						for _, func in ipairs(ModLoaderTable["chunkPopulateTag"]) do
							func(self, i, height, j)
						end
					end
				end
			end
		end

		--_JPROFILER.pop("populate")
	end

	-- get voxel id of the voxel in this chunk's coordinate space
	chunk.getVoxel = function(self, x, y, z)
		if self.voxels then
			local column = self.voxels[x]
			if column then
				local voxelData = column[z]
				if voxelData then
					if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
						local startIndex = (y - 1) * TileDataSize + 1
						local byte1, byte2, byte3 = string.byte(voxelData, startIndex, startIndex + 2)
						return byte1, byte2, byte3
					end
				end
			end
		end
		return 0, 0, 0
	end

	chunk.getVoxelData = function(self, x, y, z, dataIndex)
		x, y, z = math.floor(x), math.floor(y), math.floor(z)
		if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
			local column = self.voxels[x]
			if column then
				local voxelData = column[z]
				if voxelData then
					local startIndex = (y - 1) * TileDataSize + dataIndex
					return string.byte(voxelData, startIndex, startIndex)
				end
			end
		end
		return 0
	end

	chunk.getVoxelFirstData = function(self, x, y, z)
		return self:getVoxelData(x, y, z, 2)
	end

	chunk.getVoxelSecondData = function(self, x, y, z)
		return self:getVoxelData(x, y, z, 3)
	end

	chunk.setVoxelRaw = function(self, x, y, z, blockvalue, light)
		--_JPROFILER.push("setVoxelRaw")

		if self.voxels == nil or self.voxels[x] == nil or self.voxels[x][z] == nil then
			return 0, 0, 0
		end
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
		--_JPROFILER.pop("setVoxelRaw")
	end

	-- set voxel id of the voxel in this chunk's coordinate space
	chunk.setVoxel = function(self, x, y, z, blockvalue, manuallyPlaced)
		_JPROFILER.push("setVoxel")
		manuallyPlaced = manuallyPlaced or false
		x, y, z = math.floor(x), math.floor(y), math.floor(z)

		local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1

		if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
			--prevent block placements on the player
			local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z
			local range1 = 1
			local range2 = 0.1
			local playerXFloor = math.floor(playerX)
			local playerYFloor = math.floor(playerY)
			local playerZFloor = math.floor(playerZ)
			if
				(
					love.keyboard.isDown("space")
					and gx >= playerXFloor + 0.5 - range1
					and gx <= playerXFloor + range1
					and gy >= playerYFloor
					and gy <= playerYFloor + 1
					and gz >= playerZFloor - range1
					and gz <= playerZFloor + 0.5 + range1
				)
				or (
					not love.keyboard.isDown("space")
					and gx >= playerXFloor - range2
					and gx <= playerXFloor + range2
					and gy >= playerYFloor
					and gy <= playerYFloor + 1
					and gz >= playerZFloor - range2
					and gz <= playerZFloor + range2
				)
			then
				return
			end

			--prevent placing a block on an another block(like flowers)
			local blockBelow = self:getVoxel(x, y - 1, z)
			local blockAbove = self:getVoxel(x, y + 1, z)

			local function isBlockInTileModelTable(block)
				local value = GetValueFromTilesById(block)
				if value then
					local blockstringname = value.blockstringname
					if Tiles[blockstringname].BlockOrLiquidOrTile == TileMode.TileMode then
						return true
					end
				end
				return false
			end

			if
				(isBlockInTileModelTable(blockvalue))
				and ((isBlockInTileModelTable(blockBelow)) or (isBlockInTileModelTable(blockAbove)))
			then
				return
			end

			local sunget = self:getVoxel(x, y + 1, z)
			local sunlight = self:getVoxelFirstData(x, y + 1, z)

			local inDirectSunlight = TileLightable(sunget) and sunlight == LightSources[15]
			local placingLocalSource = false
			local destroyLight = false

			if TileLightable(blockvalue) then
				local value = GetValueFromTilesById(blockvalue)
				local blockstringname = value.blockstringname
				if
					TileTransparency(blockvalue) == TilesTransparency.NONE
					and Tiles[blockstringname].LightSources ~= 0
				then
					local blockAboveExists = false
					for checkY = y + 1, WorldHeight do
						if self:getVoxel(x, checkY, z) ~= Tiles.AIR_Block.id then
							blockAboveExists = true
							break
						end
					end
					if inDirectSunlight and not blockAboveExists then
						NewLightOperation(gx, gy, gz, "NewSunlightDownAddition", sunlight)
					end
				else
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								NewLightOperation(gx + dx, gy + dy, gz + dz, "NewSunlightAdditionCreation")
							end
						end
					end
				end

				if manuallyPlaced then
					local source = TileLightSource(blockvalue)
					if source > 0 then
						NewLightOperation(gx, gy, gz, "NewLocalLightAddition", source)
						placingLocalSource = true
					else
						for dx = -1, 1 do
							for dy = -1, 1 do
								for dz = -1, 1 do
									NewLightOperation(gx + dx, gy + dy, gz + dz, "NewLocalLightAdditionCreation")
								end
							end
						end
					end
				end
			else
				local semiLightable = TileLightable(blockvalue, true)

				NewLightOperation(gx, gy - 1, gz, "NewSunlightDownSubtraction")

				if semiLightable and inDirectSunlight and manuallyPlaced then
					NewLightOperation(gx, gy + 1, gz, "NewSunlightAdditionCreation")
				end

				if not semiLightable or manuallyPlaced then
					destroyLight = not TileLightable(blockvalue, true)
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								local nx, ny, nz = gx + dx, gy + dy, gz + dz
								local nget = GetVoxelFirstData(nx, ny, nz)
								if nget < LightSources[15] then
									NewLightOperation(nx, ny, nz, "NewSunlightSubtraction", nget + LightSources[1])
								end
							end
						end
					end
				end
			end

			local source = TileLightSource(self:getVoxel(x, y, z))
			if source > 0 and TileLightSource(blockvalue) == Tiles.AIR_Block.id then
				NewLightOperation(gx, gy, gz, "NewLocalLightSubtraction", source + LightSources[1])
				destroyLight = true
			end

			if manuallyPlaced then
				if destroyLight then
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								local nget = GetVoxelSecondData(gx + dx, gy + dy, gz + dz)
								if nget < LightSources[15] then
									NewLightOperation(
										gx + dx,
										gy + dy,
										gz + dz,
										"NewLocalLightSubtraction",
										nget + LightSources[1]
									)
								end
							end
						end
					end
				end

				if TileLightable(blockvalue, true) and not placingLocalSource then
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								NewLightOperation(gx + dx, gy + dy, gz + dz, "NewLocalLightAdditionCreation")
							end
						end
					end
				end
			end
			if blockvalue ~= -1 then
				self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

				self.changes[#self.changes + 1] = { x, y, z }
			end
		end
		_JPROFILER.pop("setVoxel")
	end

	local function setVoxelDataInternal(self, x, y, z, blockvalue, dataIndex)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local dataIndexOffset = (dataIndex == "First" and 2 or 3)
			self.voxels[x][z] =
				ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + dataIndexOffset, string.char(blockvalue))
			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	chunk.setVoxelData = function(self, x, y, z, blockvalue)
		setVoxelDataInternal(self, x, y, z, blockvalue, "First")
	end

	chunk.setVoxelFirstData = function(self, x, y, z, blockvalue)
		setVoxelDataInternal(self, x, y, z, blockvalue, "First")
	end

	chunk.setVoxelSecondData = function(self, x, y, z, blockvalue)
		setVoxelDataInternal(self, x, y, z, blockvalue, "Second")
	end

	local function initSliceUpdates()
		for i = 1, WorldHeight / SliceHeight do
			SliceUpdates[i] = { false, false, false, false, false }
		end
		return SliceUpdates
	end

	local function findUpdatedSlices(self, sliceUpdates)
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

	function updateFlaggedSlices(self, sliceUpdates)
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

	chunk.updateModel = function(self)
		_JPROFILER.push("chunk.updateModel")
		local sliceUpdates = initSliceUpdates()
		findUpdatedSlices(self, sliceUpdates)
		updateFlaggedSlices(self, sliceUpdates)

		self.changes = {}
		_JPROFILER.pop("chunk.updateModel")
	end
	_JPROFILER.pop("NewChunk")

	return chunk
end

local transparency3 = 3
function NewChunkSlice(x, y, z, parent)
	local t = NewThing(x, y, z)
	t.parent = parent
	t.name = "chunkslice"
	local compmodel = Engine.newModel(nil, LightingTexture, { 0, 0, 0 })
	compmodel.culling = false
	t:assignModel(compmodel)
	t.isUpdating = false
	t.updateModel = function(self)
		if not self or not self.parent or not self.model then
			return
		end
		self.isUpdating = true
		ChunkSliceModels = {}
		for i = 1, ChunkSize do
			for j = self.y, self.y + SliceHeight - 1 do
				for k = 1, ChunkSize do
					local this, thisSunlight, thisLocalLight = self.parent:getVoxel(i, j, k)
					local thisLight = math.max(thisSunlight, thisLocalLight)
					local thisTransparency = TileTransparency(this)
					local scale = 1
					local x, y, z = (self.x - 1) * ChunkSize + i - 1, 1 * j * scale, (self.z - 1) * ChunkSize + k - 1
					if thisTransparency < transparency3 then
						TileRendering(self, i, j, k, x, y, z, thisLight, ChunkSliceModels, scale)
						BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, ChunkSliceModels, scale)
					end
				end
			end
		end
		if self.model then
			self.model:setVerts(ChunkSliceModels)
		end
		self.isUpdating = false
	end
	t.destroyModel = function(self)
		self.model.dead = true
	end
	return t
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
