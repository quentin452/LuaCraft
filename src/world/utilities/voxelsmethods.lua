-- Retrieves voxel from a chunk, accounting for edge cases
function getVoxelFromChunk(chunkGetter, x, y, z, i, j, k)
	_JPROFILER.push("getVoxelFromChunk_blockrendering")
	local chunkGet = chunkGetter(x, y, z)
	if chunkGet ~= nil then
		_JPROFILER.pop("getVoxelFromChunk_blockrendering")
		return chunkGet:getVoxel(i, j, k)
	end
	_JPROFILER.pop("getVoxelFromChunk_blockrendering")
	return nil
end

local function GetVoxelGeneric(x, y, z, voxelFunc)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		return voxelFunc(chunk, cx, cy, cz)
	end
	return 0
end

function GetVoxel(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxel(cx, cy, cz)
	end)
end

function GetVoxelData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		local v, d = chunk:getVoxel(cx, cy, cz)
		return d
	end)
end

function GetVoxelFirstData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxelFirstData(cx, cy, cz)
	end)
end

function GetVoxelSecondData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxelSecondData(cx, cy, cz)
	end)
end

function SetVoxelGeneric(x, y, z, value, setFunction)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		setFunction(chunk, cx, cy, cz, value)
		return true
	end
	return false
end

function SetVoxel(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxel(cx, cy, cz, value)
	end)
end

function SetVoxelData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelData(cx, cy, cz, value)
	end)
end

function SetVoxelFirstData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelFirstData(cx, cy, cz, value)
	end)
end

function SetVoxelSecondData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelSecondData(cx, cy, cz, value)
	end)
end
