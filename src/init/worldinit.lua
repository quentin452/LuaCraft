function initScene()
	_JPROFILER.push("initScene")

	Scene = Engine.newScene(GraphicsWidth, GraphicsHeight)
	Scene.camera.perspective = TransposeMatrix(
		Cpml.mat4.from_perspective(90, love.graphics.getWidth() / love.graphics.getHeight(), 0.001, 10000)
	)
	_JPROFILER.pop("initScene")
end

local RandomSeed

function initGlobalRandomNumbers()
	_JPROFILER.push("initGlobalRandomNumbers")
	RandomSeed = os.time()
	math.randomseed(RandomSeed)
	Salt = {}
	for i = 1, 128 do
		Salt[i] = math.random()
	end
	ThreadLogChannel:push({ LuaCraftLoggingLevel.NORMAL, "Random Seed:", RandomSeed })
	_JPROFILER.pop("initGlobalRandomNumbers")
end

function GenerateWorld()
	_JPROFILER.push("GenerateWorld")
	initScene()
	initGlobalRandomNumbers()
	_JPROFILER.pop("GenerateWorld")
end
