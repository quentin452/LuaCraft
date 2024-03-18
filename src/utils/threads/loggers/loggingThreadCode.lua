ThreadLogChannel, LuaCraftLoggingLevel = ...
local Lovez = love
local Lovefilesystem = Lovez.filesystem
local UserDirectory = Lovefilesystem.getUserDirectory()
local Luacraftconfig = UserDirectory .. ".LuaCraft\\Luacraftconfig.txt"
local LogFilePath = UserDirectory .. "\\.LuaCraft\\Luacraft.log"

local function customReadFile(filePath)
	local file, error_message = io.open(filePath, "r")
	if file then
		local content = file:read("*a") -- *a read all things in the configurations
		file:close()
		return content
	else
		return nil, error_message
	end
end

local function writeToLog(level, ...)
	local file, err = io.open(LogFilePath, "a") -- "a" stands for append mode

	if file then
		local message = os.date("[%Y-%m-%d %H:%M:%S] ") .. level .. " "
		local args = { ... }
		for i = 1, #args do
			message = message .. tostring(args[i]) .. " "
		end
		message = message .. "\n"
		file:write(message)
		if file then
			file:close()
		end
	else
		print("Failed to open log file. Error:", err)
	end
end

local function getLuaCraftPrintLoggingValue(pattern)
	local file_content = customReadFile(Luacraftconfig)
	return file_content and file_content:match(pattern)
end

EnableLuaCraftPrintLoggingNormal = getLuaCraftPrintLoggingValue("LuaCraftPrintLoggingNormal=(%a+)")
EnableLuaCraftLoggingWarn = getLuaCraftPrintLoggingValue("LuaCraftWarnLogging=(%a+)")
EnableLuaCraftLoggingError = getLuaCraftPrintLoggingValue("LuaCraftErrorLogging=(%a+)")

local function log(level, enable, ...)
	if enable == "true" then
		writeToLog("[" .. level .. "]", ...)
		print("[" .. level .. "]", ...)
		if level == LuaCraftLoggingLevel.ERROR then
			error(...)
		end
	end
end
local function LuaCraftPrintLoggingNormal(...)
	log(LuaCraftLoggingLevel.NORMAL, EnableLuaCraftPrintLoggingNormal, ...)
end
local function LuaCraftWarnLogging(...)
	log(LuaCraftLoggingLevel.WARNING, EnableLuaCraftLoggingWarn, ...)
end

local function LuaCraftErrorLogging(...)
	log(LuaCraftLoggingLevel.ERROR, EnableLuaCraftLoggingError, ...)
end
local loggingFunctions = {
	[LuaCraftLoggingLevel.WARNING] = LuaCraftWarnLogging,
	[LuaCraftLoggingLevel.NORMAL] = LuaCraftPrintLoggingNormal,
	[LuaCraftLoggingLevel.ERROR] = LuaCraftErrorLogging,
}
while true do
	local message = ThreadLogChannel:demand()
	if message then
		local level, logMessage = unpack(message)
		if level == "ResetLoggerKeys" then
			ResetLoggerKeys = logMessage
			EnableLuaCraftPrintLoggingNormal = getLuaCraftPrintLoggingValue("LuaCraftPrintLoggingNormal=(%a+)")
			EnableLuaCraftLoggingWarn = getLuaCraftPrintLoggingValue("LuaCraftWarnLogging=(%a+)")
			EnableLuaCraftLoggingError = getLuaCraftPrintLoggingValue("LuaCraftErrorLogging=(%a+)")
		else
			local loggingFunction = loggingFunctions[level]
			if loggingFunction then
				loggingFunction(logMessage)
			else
				LuaCraftErrorLogging("You used a wrong level for logging:" .. level)
			end
		end
	end
end
