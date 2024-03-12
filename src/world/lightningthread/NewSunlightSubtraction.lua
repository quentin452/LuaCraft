local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
function NewSunlightSubtraction(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, queryType = "NewSunlightSubtraction" }
	LightingRemovalQueue:push(t)
end
function queryNewSunlightSubtraction(lthing)
	local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
	if cget == nil then
		return
	end
	local val = cget:getVoxel(cx, cy, cz)
	local fget = cget:getVoxelFirstData(cx, cy, cz)
	if fget > 0 and lthing.value >= 0 and TileSemiLightable(val) then
		if fget < lthing.value then
			cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewSunlightSubtraction(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, fget)
			end
		else
			NewSunlightForceAddition(lthing.x, lthing.y, lthing.z, fget)
		end
		return false
	end
end
