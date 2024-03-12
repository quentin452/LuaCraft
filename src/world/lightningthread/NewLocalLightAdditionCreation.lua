function NewLocalLightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z, queryType = "NewLocalLightAdditionCreation" }
	LightingQueue:push(t)
end


function queryNewLocalLightAdditionCreation(lthing)
    local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
    if cget == nil then
        return
    end
    local val, dis, dat = cget:getVoxel(cx, cy, cz)
    if TileSemiLightable(val) and dat > 0 then
        NewLocalLightForceAddition(lthing.x, lthing.y, lthing.z, dat)
    end
end
