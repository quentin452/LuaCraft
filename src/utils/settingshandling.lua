local configParams = {
	vsync = { variable = "GlobalVSync", setter = Lovewindow.setVSync },
	LuaCraftPrintLoggingNormal = { variable = "EnableLuaCraftPrintLoggingNormal" },
	LuaCraftWarnLogging = { variable = "EnableLuaCraftLoggingWarn" },
	LuaCraftErrorLogging = { variable = "EnableLuaCraftLoggingError" },
	forwardmovementkey = { variable = "ReloadForwardKey", expectedValue = "z" },
	backwardmovementkey = { variable = "ReloadBackwardKey", expectedValue = "s" },
	leftmovementkey = { variable = "ReloadLeftKey", expectedValue = "q" },
	rightmovementkey = { variable = "ReloadRightKey", expectedValue = "d" },
}

local function reloadConfig()
	local file_content, error_message = customReadFile(Luacraftconfig)
	if not file_content then
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
	for param, info in pairs(configParams) do
		local value = file_content:match(param .. "=([%a%d]+)")
		if value then
			if info.expectedValue then
				_G[info.variable] = value:lower() == info.expectedValue
			else
				_G[info.variable] = value:lower() == "true"
			end
			if info.setter then
				info.setter(_G[info.variable] and 1 or 0)
			end
		end
	end
end
local function toggleSetting(settingName, currentValue)
	_JPROFILER.push("toggleSetting")
	_G[settingName] = not currentValue
	local file_content, error_message = customReadFile(Luacraftconfig)
	if not file_content then
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
	local printValue = _G[settingName] and "true" or "false"
	file_content = file_content:gsub(settingName .. "=%w+", settingName .. "=" .. printValue)
	local file, error_message = io.open(Luacraftconfig, "w")
	if not file then
		LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		return
	end
	file:write(file_content)
	file:close()
	_JPROFILER.pop("toggleSetting")
end

local function updateLoggingSetting(settingName, configKey)
	_G[settingName] = not _G[settingName]
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		local printValue = _G[settingName] and "true" or "false"
		file_content = file_content:gsub(configKey .. "=%w+", configKey .. "=" .. printValue)
		local file, error_message = io.open(Luacraftconfig, "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
end
local function renderdistanceSetting()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 0
		GlobalRenderDistance = current_renderdistance + 2

		if GlobalRenderDistance > 20 then
			GlobalRenderDistance = 2
		end

		file_content = file_content:gsub("renderdistance=(%d+)", "renderdistance=" .. GlobalRenderDistance)

		local file, error_message = io.open(Luacraftconfig, "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
	return GlobalRenderDistance
end

function getRenderDistanceValue()
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 6
		return current_renderdistance * 16 --ChunkSize
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
end

function LuaCraftSettingsUpdater(WantToBeUpdated)
	if WantToBeUpdated == "NormalLoggingToggler" then
		updateLoggingSetting("EnableLuaCraftPrintLoggingNormal", "LuaCraftPrintLoggingNormal")
	elseif WantToBeUpdated == "WarnLoggingToggler" then
		updateLoggingSetting("EnableLuaCraftLoggingWarn", "LuaCraftWarnLogging")
	elseif WantToBeUpdated == "ErrorLoggingToggler" then
		updateLoggingSetting("EnableLuaCraftLoggingError", "LuaCraftErrorLogging")
	elseif WantToBeUpdated == "renderdistanceSetting" then
		renderdistanceSetting()
	elseif WantToBeUpdated == "toggleVSync" then
		GlobalVSync = not GlobalVSync
		toggleSetting("vsync", not GlobalVSync)
		Lovewindow.setVSync(GlobalVSync and 1 or 0)
	elseif WantToBeUpdated == "toggleFullScreen" then
		GlobalFullscreen = not GlobalFullscreen
		toggleSetting("fullscreen", not GlobalFullscreen)
		Lovewindow.setFullscreen(GlobalFullscreen, "desktop")
	else
		LuaCraftErrorLogging("WhantToBeToggled is not a good value: " .. WantToBeUpdated)
	end
end

function SettingsHandlingInit()
	_JPROFILER.push("SettingsHandlingInit")
	reloadConfig()
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		local vsyncValue = file_content:match("vsync=(%d)")
		if vsyncValue then
			Lovewindow.setVSync(tonumber(vsyncValue))
		end
		local renderdistanceValue = file_content:match("renderdistance=(%d)")
		GlobalRenderDistance = tonumber(renderdistanceValue)
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("SettingsHandlingInit")
end

local function openLogFile(mode)
	return io.open(LogFilePath, mode)
end

local function closeLogFile(file)
	if file then
		file:close()
	end
end

local function writeToLog(level, ...)
	local file, err = openLogFile("a") -- "a" stands for append mode

	if file then
		local message = os.date("[%Y-%m-%d %H:%M:%S] ") .. "[" .. level .. "] " .. table.concat({ ... }, " ") .. "\n"
		file:write(message)
		closeLogFile(file)
	else
		print("Failed to open log file. Error:", err)
	end
end
function getLuaCraftPrintLoggingNormalValue()
	local file_content, error_message = customReadFile(Luacraftconfig)
	return file_content and file_content:match("LuaCraftPrintLoggingNormal=(%d)")
end

function getLuaCraftPrintLoggingWarnValue()
	local file_content, error_message = customReadFile(Luacraftconfig)
	return file_content and file_content:match("LuaCraftWarnLogging=(%d)")
end

function getLuaCraftPrintLoggingErrorValue()
	local file_content, error_message = customReadFile(Luacraftconfig)
	return file_content and file_content:match("LuaCraftErrorLogging=(%d)")
end
local function log(level, enable, ...)
	if enable then
		local message = table.concat({ ... }, " ")
		writeToLog("[" .. level .. "]", message)
		print("[" .. level .. "]", message)
	end
end
EnableLuaCraftPrintLoggingNormal = getLuaCraftPrintLoggingNormalValue()
function LuaCraftPrintLoggingNormal(...)
	log("NORMAL", EnableLuaCraftPrintLoggingNormal, ...)
end
EnableLuaCraftLoggingWarn = getLuaCraftPrintLoggingWarnValue()
function LuaCraftWarnLogging(...)
	log("WARN", EnableLuaCraftLoggingWarn, ...)
end
EnableLuaCraftLoggingError = getLuaCraftPrintLoggingErrorValue()
function LuaCraftErrorLogging(...)
	log("FATAL", EnableLuaCraftLoggingError, ...)
end
