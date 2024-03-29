function createLoggingThread()
	local thread = love.thread.newThread("src/utils/threads/loggers/loggingThreadCode.lua")
	thread:start(ThreadLogChannel, LuaCraftLoggingLevel)
	return ThreadLogChannel
end
