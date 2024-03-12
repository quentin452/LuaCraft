local FOURDIRECTIONS = {
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
function NewSunlightDownSubtraction(x, y, z)
	local t = { x = x, y = y, z = z, queryType = "NewSunlightDownSubtraction" }
	LightingRemovalQueue:push(t)
end

function queryNewSunlightDownSubtraction(lthing)
	if TileSemiLightable(GetVoxel(lthing.x, lthing.y, lthing.z)) then
		SetVoxelFirstData(lthing.x, lthing.y, lthing.z, Tiles.AIR_Block.id)
		NewSunlightDownSubtraction(lthing.x, lthing.y - 1, lthing.z)
		for _, dir in ipairs(FOURDIRECTIONS) do
			NewSunlightSubtraction(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, LightSources[15])
		end
		-- NewSunlightSubtraction(self.x,self.y-1,self.z, LightSources[15])
		return true
	end
end
