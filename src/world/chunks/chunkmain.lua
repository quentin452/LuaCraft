local transparency3 = 3
local caveConfigs = {
	{ minHeight = 8, maxHeight = 64, count = rand(1, 3) },
	{ minHeight = 48, maxHeight = 80, count = rand(1, 2) },
}
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
	--TODO Made a config to change the Terrain Generation WorldType in worldcreationmenu.lua
	GenerateTerrain(chunk, x, z, StandardTerrain)
	local gx, gz = (chunk.x - 1) * ChunkSize + rand(0, 15), (chunk.z - 1) * ChunkSize + rand(0, 15)
	if choose({ true, false }) then
		for _, config in ipairs(caveConfigs) do
			for i = 1, config.count do
				NewCave(gx, rand(config.minHeight, config.maxHeight), gz)
			end
		end
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
		for j = 1, #self.requests do
			local block = self.requests[j]
			if not TileCollisions(self:getVoxel(block.x, block.y, block.z)) then
				self:setVoxel(block.x, block.y, block.z, block.value, false)
			end
		end
	end

	-- populate chunk with trees and flowers
	chunk.populate = function(self)
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
		if self.voxels == nil or self.voxels[x] == nil or self.voxels[x][z] == nil then
			return 0, 0, 0
		end
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local _, _, _ = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end
	-- set voxel id of the voxel in this chunk's coordinate space
	chunk.setVoxel = function(self, x, y, z, blockvalue, manuallyPlaced)
		_JPROFILER.push("setVoxel")
		manuallyPlaced = manuallyPlaced or false
		x, y, z = math.floor(x), math.floor(y), math.floor(z)
		local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
		if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
			if
				PreventBlockPlacementOnThePlayer(gx, gy, gz)
				or PreventBlockPlacementOnCertainBlocksLikeFlower(self, x, y, z, blockvalue)
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
									local xd, yd, zd = gx + dx, gy + dy, gz + dz
									NewLightOperation(xd, yd, zd, "NewLocalLightSubtraction", nget + LightSources[1])
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
	chunk.setVoxelData = function(self, x, y, z, blockvalue)
		SetVoxelDataInternal(self, x, y, z, blockvalue, "First")
	end
	chunk.setVoxelFirstData = function(self, x, y, z, blockvalue)
		SetVoxelDataInternal(self, x, y, z, blockvalue, "First")
	end
	chunk.setVoxelSecondData = function(self, x, y, z, blockvalue)
		SetVoxelDataInternal(self, x, y, z, blockvalue, "Second")
	end
	chunk.updateModel = function(self)
		_JPROFILER.push("chunk.updateModel")
		local sliceUpdates = InitSliceUpdates()
		FindUpdatedSlices(self, sliceUpdates)
		UpdateFlaggedSlices(self, sliceUpdates)
		self.changes = {}
		_JPROFILER.pop("chunk.updateModel")
	end
	_JPROFILER.pop("NewChunk")
	return chunk
end