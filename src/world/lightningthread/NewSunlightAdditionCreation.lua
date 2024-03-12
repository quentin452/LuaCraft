function NewSunlightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z, queryType = "NewSunlightAdditionCreation" }
    LightingQueue:push(t)
end

function queryNewSunlightAdditionCreation(lthing)
	local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
	if cget == nil then
		return
	end
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if TileSemiLightable(val) and dat > 0 then
		NewSunlightForceAddition(lthing.x, lthing.y, lthing.z, dat)
	end
end
