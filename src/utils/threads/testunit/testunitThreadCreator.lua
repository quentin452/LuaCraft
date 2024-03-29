function createTestUnitThread()
	local thread = love.thread.newThread("src/utils/threads/testunit/testunitThreadCode.lua")
	thread:start(
		TestUnitThreadChannel,
		ThreadLogChannel,
		LuaCraftLoggingLevel,
		EnableTestUnitWaitingScreen,
		EnableTestUnitWaitingScreenChannel
	)
	return TestUnitThreadChannel
end
