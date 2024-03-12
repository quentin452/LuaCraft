local FOURDIRECTIONS = {
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

function NewSunlightDownAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, queryType = "NewSunlightDownAddition" }
	LightingQueue:push(t)
end

function queryNewSunlightDownAddition(lthing)
    local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
	if cget == nil then
		return
	end
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if TileLightable(val) and dat <= lthing.value then
        cget:setVoxelFirstData(cx, cy, cz, lthing.value)
        NewSunlightDownAddition(lthing.x, lthing.y - 1, lthing.z, lthing.value)
        for _, dir in ipairs(FOURDIRECTIONS) do
            NewSunlightAddition(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, lthing.value - 1)
        end
    end
end
