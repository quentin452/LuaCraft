local temp = {}
local dirt = 4
local grass = true
local OneHundredThoused = 100000
function GenerateTerrain(chunk, x, z, generationFunction)
	_JPROFILER.push("GenerateTerrain")
	for i = 1, ChunkSize do
		chunk.voxels[i] = {}
		local xx = (x - 1) * ChunkSize + i
		for k = 1, ChunkSize do
			local zz = (z - 1) * ChunkSize + k
			chunk.heightMap[i][k] = 0
			local sunlight = true
			for j = WorldHeight, 1, -1 do
				local yy = (j - 1) * TileDataSize + 1
				local genFuncResult = generationFunction(chunk, xx, j, zz)
				for a = 1, TileDataSize - 1 do
					temp[yy + a] = string.char(LightSources[0])
				end
				if sunlight then
					temp[yy + 1] = string.char(LightSources[15])
				end
				if j < chunk.floor then
					temp[yy] = string.char(Tiles.STONE_Block.id)
					sunlight = false
				else
					temp[yy] = string.char(Tiles.AIR_Block.id)
					if genFuncResult then
						if not grass and dirt > 0 then
							dirt = dirt - 1
							temp[yy] = string.char(Tiles.DIRT_Block.id)
						elseif not grass then
							temp[yy] = string.char(Tiles.STONE_Block.id)
						else
							grass = false
							temp[yy] = string.char(Tiles.GRASS_Block.id)
						end
						if sunlight then
							chunk.heightMap[i][k] = j
							sunlight = false
						end
					else
						grass = true
						dirt = 4
					end
				end
			end
			chunk.voxels[i][k] = table.concat(temp)
		end
	end
	temp = {}
	_JPROFILER.pop("GenerateTerrain")
end

function StandardTerrain(chunk, xx, j, zz)
	return ChunkNoise(xx, j, zz)
		> (j - chunk.floor) / (chunk.ceiling - chunk.floor) * (Noise2D(xx, zz, 128, 5) * 0.75 + 0.75)
end

function ClassicTerrain(chunk, xx, j, zz)
	_JPROFILER.push("ClassicTerrain")

	local scalar = 1.3
	local heightLow = (OctaveNoise(xx * scalar, zz * scalar, 8, 2, 3) + OctaveNoise(xx * scalar, zz * scalar, 8, 4, 5))
			/ 6
		- 4
	local heightHigh = (OctaveNoise(xx * scalar, zz * scalar, 8, 6, 7) + OctaveNoise(xx * scalar, zz * scalar, 8, 8, 9))
			/ 5
		- 6
	local heightResult = heightLow

	if OctaveNoise(xx, zz, 6, 10, 11) / 8 <= 0 then
		heightResult = math.max(heightLow, heightHigh)
	end

	heightResult = heightResult * 0.5
	if heightResult < 0 then
		heightResult = heightResult * 0.8
	end

	heightResult = heightResult + 64 -- water level
	_JPROFILER.pop("ClassicTerrain")

	return j <= heightResult --ChunkNoise(xx,j,zz) > (j-chunk.floor)/(chunk.ceiling-chunk.floor)*(Noise2D(xx,zz, 128,5)*0.75 +0.75)
end

-- noise function used in chunk generation
function ChunkNoise(x, y, z)
	return Noise(x, y, z, 20, 12, 1)
end

function Noise(x, y, z, freq, yfreq, si)
	return love.math.noise(
		x / freq + Salt[si] * OneHundredThoused,
		y / yfreq + Salt[si + 1] * OneHundredThoused,
		z / freq + Salt[si + 2] * OneHundredThoused
	)
end
function Noise2D(x, z, freq, si)
	return love.math.noise(x / freq + Salt[si] * OneHundredThoused, z / freq + Salt[si + 2] * OneHundredThoused)
end
function OctaveNoise(x, y, octaves, seed1, seed2)
	local ret = 0

	local freq = 1
	local amp = 1
	for i = 1, octaves do
		ret = ret
			+ love.math.noise(x * freq + Salt[seed1] * OneHundredThoused, y * freq + Salt[seed2] * OneHundredThoused) * amp
			- amp / 2
		freq = freq * 0.5
		amp = amp * 2
	end

	return ret
end
GlobalWorldType = StandardTerrain

WorldTypeMap = {
    [StandardTerrain] = { name = "Standard Terrain", nextType = ClassicTerrain },
    [ClassicTerrain] = { name = "Classic Terrain", nextType = StandardTerrain },
}