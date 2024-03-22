local caveConfigs = {
	{ minHeight = 8, maxHeight = 64, count = rand(1, 3) },
	{ minHeight = 48, maxHeight = 80, count = rand(1, 2) },
}
local MAX_EXECUTION_TIME = 0.5
local totalLongExecutionTime = 0
local populatelog1 = "Function from"
local populatelog2 = "in chunkPopulateTag took too long to execute. Total time taken "
function NewChunk(x, z)
	_JPROFILER.push("NewChunk")
	local chunk = NewThing(x, 0, z)
	chunk.voxels = {}
	chunk.slices = {}
	chunk.heightMap = {}
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
	GenerateTerrain(chunk, x, z, GlobalWorldType)
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
						NewLightOperation(gridX - 1, this, gridZ, LightOpe.SunDownAdd.id, LightSources[15])
						--[[ThreadLightingChannel:push({"LightOperation",gridX - 1,this,gridZ,LightOpe.SunDownAdd.id,LightSources[15],})]]
					end
					if j == 1 or this > self.heightMap[i][j - 1] then
						NewLightOperation(gridX, this, gridZ - 1, LightOpe.SunDownAdd.id, LightSources[15])
						--[[	ThreadLightingChannel:push({"LightOperation",gridX,this,gridZ - 1,LightOpe.SunDownAdd.id,LightSources[15],})]]
					end
					if i == ChunkSize or this > self.heightMap[i + 1][j] then
						NewLightOperation(gridX + 1, this, gridZ, LightOpe.SunDownAdd.id, LightSources[15])
						--[[	ThreadLightingChannel:push({"LightOperation",gridX + 1,this,gridZ,LightOpe.SunDownAdd.id,LightSources[15],})]]
					end
					if j == ChunkSize or this > self.heightMap[i][j + 1] then
						NewLightOperation(gridX, this, gridZ + 1, LightOpe.SunDownAdd.id, LightSources[15])
						--[[ThreadLightingChannel:push({"LightOperation",	gridX,this,	gridZ + 1,	LightOpe.SunDownAdd.id,	LightSources[15],	})]]
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
		totalLongExecutionTime = 0
		for i = 1, ChunkSize do
			local heightMap_i = self.heightMap[i]
			if heightMap_i then
				for j = 1, ChunkSize do
					local height = heightMap_i[j]
					if height and TileCollisions(self:getVoxel(i, height, j)) then
						for _, taggedFunc in ipairs(ModLoaderTable["chunkPopulateTag"]) do
							local start_time = love.timer.getTime()
							taggedFunc.func(self, i, height, j)
							local elapsed_time = love.timer.getTime() - start_time
							if elapsed_time > MAX_EXECUTION_TIME then
								totalLongExecutionTime = totalLongExecutionTime + elapsed_time
								local log3 = totalLongExecutionTime
								ThreadLogChannel:push({
									LuaCraftLoggingLevel.WARNING,
									populatelog1 .. taggedFunc.sourcePath .. populatelog2 .. log3 .. " seconds.",
								})
							end
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
					if IsWithinChunkLimits(x, y, z) then
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
		if IsWithinChunkLimits(x, y, z) then
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
	chunk.setVoxelRawNotSupportLight = function(self, x, y, z, blockvalue)
		if self.voxels == nil or self.voxels[x] == nil or self.voxels[x][z] == nil then
			return 0, 0, 0
		end
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local _, _, _ = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
			UpdateVoxelData(self, blockvalue, x, y, z)
		end
	end
	--TODO continue optimizing chunk.setVoxel
	--[[
    Sets a voxel at the specified position in the chunk.

    @param x             The x-coordinate of the voxel position.
    @param y             The y-coordinate of the voxel position.
    @param z             The z-coordinate of the voxel position.
    @param blockvalue    The value of the block to set.
    @param manuallyPlaced    A boolean indicating if the block was manually placed.

    @return              Nothing.
--]]
	chunk.setVoxel = function(self, x, y, z, blockvalue, manuallyPlaced)
		SetVoxelInternal(manuallyPlaced, self, x, y, z, blockvalue)
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
