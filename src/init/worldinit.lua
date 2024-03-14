function initScene()
	_JPROFILER.push("initScene")

	Scene = Engine.newScene(GraphicsWidth, GraphicsHeight)
	Scene.camera.perspective = TransposeMatrix(
		cpml.mat4.from_perspective(90, love.graphics.getWidth() / love.graphics.getHeight(), 0.001, 10000)
	)
	if enablePROFIProfiler then
		ProFi:checkMemory(1, "Premier profil")
	end
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

	if enablePROFIProfiler then
		ProFi:checkMemory(2, "Second profil")
	end
	LuaCraftPrintLoggingNormal("Random Seed:", RandomSeed)
	_JPROFILER.pop("initGlobalRandomNumbers")
end

function GenerateWorld()
	_JPROFILER.push("GenerateWorld")
	initScene()
	initGlobalRandomNumbers()
	if enablePROFIProfiler then
		ProFi:checkMemory(9, "9eme profil")
	end
	_JPROFILER.pop("GenerateWorld")
end