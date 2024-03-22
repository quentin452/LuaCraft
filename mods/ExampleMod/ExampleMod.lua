--mod dependencies (here you should add all lua of your mod here to don't had problems during initialize)
require("mods/ExampleMod/structures/ExampleMod_generatestructures")
require("mods/ExampleMod/structures/ExampleMod_generatetree")

local ExampleMod = {}

function ExampleMod.initialize()
	addFunctionToTag("chunkPopulateTag", function(self, i, height, j)
		local xx = (self.x - 1) * ChunkSize + i
		local zz = (self.z - 1) * ChunkSize + j
		if love.math.noise(xx / 32, zz / 32) > 0.9 and math.random() < 0.2 then
			local min = math.min(Tiles.YELLO_FLOWER_Block.id, Tiles.ROSE_FLOWER_Block.id)
			local max = math.max(Tiles.YELLO_FLOWER_Block.id, Tiles.ROSE_FLOWER_Block.id)

			local flowerID = math.random(min, max)
			self:setVoxelRawNotSupportLight(i, height + 1, j, flowerID)
		end
		if math.random() < love.math.noise(xx / 64, zz / 64) * 0.02 then
			ExampleMod_GenerateTree(self, i, height, j)
			self:setVoxelRawNotSupportLight(i, height, j, Tiles.DIRT_Block.id)
		end
	end, GetSourcePath())
end

return ExampleMod
