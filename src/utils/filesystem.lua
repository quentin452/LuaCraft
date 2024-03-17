local DefaultSettings = {
	vsync = true,
	LuaCraftPrintLoggingNormal = true,
	LuaCraftWarnLogging = true,
	LuaCraftErrorLogging = true,
	renderdistance = 2,
	fullscreen = false,
	forwardmovementkey = "z",
	backwardmovementkey = "s",
	leftmovementkey = "q",
	rightmovementkey = "d",
}

Ffi.cdef([[
    int CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    int GetLastError(void);
    int _access(const char* path, int mode);
]])

function directoryExists(path)
	return Ffi.C._access(path, 0) == 0
end

function createDirectoryIfNotExists(directoryPath)
	if not directoryExists(directoryPath) then
		local success = Ffi.C.CreateDirectoryA(directoryPath, nil)
		if success == 0 then
			local err = Ffi.C.GetLastError()
			error("Failed to create directory. Error code: " .. err)
		end
	end
end
function customReadFile(filePath)
	local file, error_message = io.open(filePath, "r")
	if file then
		local content = file:read("*a") -- *a read all things in the configurations
		file:close()
		return content
	else
		return nil, error_message
	end
end
function createFileIfNotExists(filePath)
	local file, err = io.open(filePath, "r")
	if not file then
		local directory = filePath:match("(.+\\).-$")
		if not directoryExists(directory) then
			createDirectoryIfNotExists(directory)
		end
		file, err = io.open(filePath, "w")
		if not file then
			error("Failed to create file. Error: " .. err)
		end
		file:close()
	else
		file:close()
	end
end

function loadAndSaveLuaCraftFileSystem()
	_JPROFILER.push("loadAndSaveLuaCraftFileSystem")
	local file_content, error_message = customReadFile(Luacraftconfig)
	createFileIfNotExists(Luacraftconfig)
	if not file_content or file_content == "" then
		file_content = generateDefaultConfig(DefaultSettings)
	end
	local orderedKeys = {
		"vsync",
		"LuaCraftPrintLoggingNormal",
		"LuaCraftWarnLogging",
		"LuaCraftErrorLogging",
		"renderdistance",
		"fullscreen",
		"forwardmovementkey",
		"backwardmovementkey",
		"leftmovementkey",
		"rightmovementkey",
	}
	local settings = {}
	for _, key in ipairs(orderedKeys) do
		local value = file_content:match(key .. "=([^%c]+)")
		if value then
			settings[key] = value
		end
	end
	for key, value in pairs(DefaultSettings) do
		settings[key] = settings[key] or value
	end
	local file, error_message = io.open(Luacraftconfig, "w")
	if file then
		for _, key in ipairs(orderedKeys) do
			file:write(key .. "=" .. tostring(settings[key]) .. "\n")
		end
		file:close()
	else
		error("Failed to open file for writing. Error: " .. error_message)
	end
	_JPROFILER.pop("loadAndSaveLuaCraftFileSystem")
end

function generateDefaultConfig(defaults)
	local content = {}
	for key, value in pairs(defaults) do
		table.insert(content, key .. "=" .. tostring(value))
	end
	return table.concat(content, "\n") .. "\n"
end

function saveLogsToOldLogsFolder()
	local oldLogsFolder = UserDirectory .. ".LuaCraft\\old_logs\\"
	local timestamp = os.date("%Y%m%d%H%M%S")
	local newLogFilePath = oldLogsFolder .. "luacraftlog_" .. timestamp .. ".txt"

	createDirectoryIfNotExists(oldLogsFolder)

	local currentLogContent, error_message = customReadFile(LogFilePath)

	if currentLogContent then
		local file, error_message = io.open(newLogFilePath, "w")
		if file then
			file:write(currentLogContent)
			file:close()
			print("Logs saved to old_logs folder.")

			local resetFile, resetError = io.open(LogFilePath, "w")
			if resetFile then
				resetFile:close()
			else
				error("Failed to reset main log file. Error: " .. resetError)
			end
		else
			error("Failed to open file for writing. Error: " .. error_message)
		end
	else
		error("Failed to read current log file. Error: " .. error_message)
	end
end
