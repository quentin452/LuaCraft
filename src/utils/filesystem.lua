Settings = {}
local logFilePath = userDirectory .. "\\.LuaCraft\\luacraftconfig.log"

function writeToLog(string, message)
	local file, err = io.open(logFilePath, "a") -- "a" stands for append mode

	if file then
		file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. string .. message .. "\n")
		file:close()
	else
		--LuaCraftErrorLogging("Failed to open log file. Error: " .. err)
	end
end

Settings = {}

function checkAndUpdateDefaults(Settings)
	_JPROFILER.push("checkAndUpdateDefaults")
	if Settings["vsync"] == nil then
		Settings["vsync"] = true
	end
	if Settings["LuaCraftPrintLoggingNormal"] == nil then
		Settings["LuaCraftPrintLoggingNormal"] = true
	end
	if Settings["LuaCraftWarnLogging"] == nil then
		Settings["LuaCraftWarnLogging"] = true
	end
	if Settings["LuaCraftErrorLogging"] == nil then
		Settings["LuaCraftErrorLogging"] = true
	end
	if Settings["renderdistance"] == nil then
		Settings["renderdistance"] = 5
	end
	if Settings["goodlyinitializedconfigs"] == nil then
		Settings["goodlyinitializedconfigs"] = 0
	end
	_JPROFILER.pop("checkAndUpdateDefaults")
end

function customReadFile(filePath)
	--_JPROFILER.push("customReadFile")

	local file, error_message = io.open(filePath, "r")

	if file then
		local content = file:read("*a") -- *a read all things in the configurations
		file:close()
		--	_JPROFILER.pop("customReadFile")
		return content
	else
		return nil, error_message
	end
end

function createFileIfNotExists(filePath)
	local file, err = io.open(filePath, "r")

	if not file then
		-- Créer le répertoire s'il n'existe pas
		local directory = filePath:match("(.+\\).-$")
		os.execute('mkdir "' .. directory .. '"')

		file, err = io.open(filePath, "w")

		if not file then
			error("Failed to create file. Error: " .. err)
		end

		file:close()
		LuaCraftPrintLoggingNormal("Created file: " .. filePath)
	else
		file:close()
	end
end

function loadAndSaveLuaCraftFileSystem()
	_JPROFILER.push("loadAndSaveLuaCraftFileSystem")

	LuaCraftPrintLoggingNormal("Attempting to load LuaCraft settings")

	local luaCraftDirectory = userDirectory .. ".LuaCraft\\"
	local configFilePath = luaCraftDirectory .. "luacraftconfig.txt"

	-- Check and create file if not exists
	createFileIfNotExists(configFilePath)

	LuaCraftPrintLoggingNormal("Directory contents before attempting to load settings:")
	for _, item in ipairs(love.filesystem.getDirectoryItems(luaCraftDirectory)) do
		LuaCraftPrintLoggingNormal(item)
	end

	LuaCraftPrintLoggingNormal("Config file path: " .. configFilePath)

	local file_content, error_message = customReadFile(configFilePath)

	if file_content then
		local Settings = {}
		local orderedKeys =
			{ "vsync", "LuaCraftPrintLoggingNormal", "LuaCraftWarnLogging", "LuaCraftErrorLogging", "renderdistance" , "goodlyinitializedconfigs" }

		for _, key in ipairs(orderedKeys) do
			local value = file_content:match(key .. "=(%w+)")
			if value then
				local numValue = tonumber(value)
				Settings[key] = numValue or (value == "true")
			end
		end

		LuaCraftPrintLoggingNormal("Settings loaded successfully.")

		-- Verify and Update Default Values
		checkAndUpdateDefaults(Settings)

		-- Open the file in Writter mod
		local file, error_message = io.open(configFilePath, "w")

		if file then
			-- Write parameters with verifications
			for _, key in ipairs(orderedKeys) do
				file:write(key .. "=" .. tostring(Settings[key]) .. "\n")
			end

			file:close()
			LuaCraftPrintLoggingNormal("Settings loaded and saved to luacraftconfig.txt")
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to open file for reading. Error: " .. error_message)
	end
	_JPROFILER.pop("loadAndSaveLuaCraftFileSystem")
end

function getLuaCraftPrintLoggingNormalValue()
	local configFilePath = userDirectory .. ".LuaCraft\\luacraftconfig.txt"
	local file_content, error_message = customReadFile(configFilePath)
	return file_content and file_content:match("LuaCraftPrintLoggingNormal=(%d)")
end

function getLuaCraftPrintLoggingWarnValue()
	local configFilePath = userDirectory .. ".LuaCraft\\luacraftconfig.txt"
	local file_content, error_message = customReadFile(configFilePath)
	return file_content and file_content:match("LuaCraftWarnLogging=(%d)")
end

function getLuaCraftPrintLoggingErrorValue()
	local configFilePath = userDirectory .. ".LuaCraft\\luacraftconfig.txt"

	local file_content, error_message = customReadFile(configFilePath)
	return file_content and file_content:match("LuaCraftErrorLogging=(%d)")
end

EnableLuaCraftPrintLoggingNormalLogging = getLuaCraftPrintLoggingNormalValue()

function LuaCraftPrintLoggingNormal(...)
	
	--print(EnableLuaCraftPrintLoggingNormalLogging)
	--if EnableLuaCraftLoggingError == nil then
	--	EnableLuaCraftLoggingError = true
	--end
	--if EnableLuaCraftLoggingWarn == nil then
	--		EnableLuaCraftLoggingWarn = true
	--	end
	--	if EnableLuaCraftPrintLoggingNormalLogging == nil then
	--		EnableLuaCraftPrintLoggingNormalLogging = true
	--	end
	if EnableLuaCraftPrintLoggingNormalLogging then
		writeToLog("[NORMAL]", ...)
		print("[NORMAL]", ...)
	end
end

EnableLuaCraftLoggingWarn = getLuaCraftPrintLoggingWarnValue()

function LuaCraftWarnLogging(...)
	if EnableLuaCraftLoggingWarn then
		writeToLog("[WARN]", ...)
		print("[WARN]", ...)
	end
end

EnableLuaCraftLoggingError = getLuaCraftPrintLoggingErrorValue()

function LuaCraftErrorLogging(...)
	if EnableLuaCraftLoggingError then
		writeToLog("[FATAL]", ...)
		error(...)
	end
end

local logFilePath = userDirectory .. "\\.LuaCraft\\luacraftconfig.log"

function writeToLog(string, message)
	local file, err = io.open(logFilePath, "a") -- "a" stands for append mode

	if file then
		file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. string .. message .. "\n")
		file:close()
	else
		--LuaCraftErrorLogging("Failed to open log file. Error: " .. err)
	end
end
