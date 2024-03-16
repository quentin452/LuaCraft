function reloadConfig()
	local file_content, error_message = customReadFile(Luacraftconfig)
	if file_content then
		local vsyncValue = file_content:match("vsync=(%w+)")
		if vsyncValue then
			GlobalVSync = vsyncValue:lower() == "true"
			Lovewindow.setVSync(GlobalVSync and 1 or 0)
		end

		--	local renderdistanceValue = file_content:match("renderdistance=(%d+)")
		--	globalRenderDistance = tonumber(renderdistanceValue) or 6

		local printNormalValue = file_content:match("LuaCraftPrintLoggingNormal=(%w+)")
		EnableLuaCraftPrintLoggingNormalLogging = printNormalValue:lower() == "true"

		local warnValue = file_content:match("LuaCraftWarnLogging=(%w+)")
		EnableLuaCraftLoggingWarn = warnValue:lower() == "true"

		local errorValue = file_content:match("LuaCraftErrorLogging=(%w+)")
		EnableLuaCraftLoggingError = errorValue:lower() == "true"
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end
end

function toggleFullScreen()
	_JPROFILER.push("toggleFullScreen")
	GlobalFullscreen = not GlobalFullscreen

	local fullscreenSetting = GlobalFullscreen and "true" or "false"

	-- Update the configuration file
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		file_content = file_content:gsub("fullscreen=%w+", "fullscreen=" .. fullscreenSetting)

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

	-- Set the window to fullscreen
	local fullscreen = GlobalFullscreen
	local fullscreenType = "desktop" -- Can be "desktop" or "exclusive"
	love.window.setFullscreen(fullscreen, fullscreenType)

	_JPROFILER.pop("toggleFullScreen")
end

function toggleVSync()
	_JPROFILER.push("toggleVSync")
	GlobalVSync = not GlobalVSync
	Lovewindow.setVSync(GlobalVSync and 1 or 0)

	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		file_content = file_content:gsub("vsync=%w+", "vsync=" .. (GlobalVSync and "true" or "false"))
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
	_JPROFILER.pop("toggleVSync")
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
function getForwardMovementKeyValue()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local forward_movement_key = file_content:match("forwardmovementkey=([%a%d]+)")
		return forward_movement_key or "z"
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
end
function getBackwardMovementKeyValue()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local forward_movement_key = file_content:match("backwardmovementkey=([%a%d]+)")
		return forward_movement_key or "s"
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
end
function getLeftMovementKeyValue()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local forward_movement_key = file_content:match("leftmovementkey=([%a%d]+)")
		return forward_movement_key or "q"
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
end
function getRightMovementKeyValue()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local forward_movement_key = file_content:match("rightmovementkey=([%a%d]+)")
		return forward_movement_key or "d"
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
		return
	end
end
function renderdistanceSetting()
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 0
		globalRenderDistance = current_renderdistance + 2

		if globalRenderDistance > 20 then
			globalRenderDistance = 2
		end

		file_content = file_content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)

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
	return globalRenderDistance
end

function printNormalLoggingSettings()
	_JPROFILER.push("printNormalLoggingSettings")
	EnableLuaCraftPrintLoggingNormalLogging = not EnableLuaCraftPrintLoggingNormalLogging
	-- Load current contents of Luacraftconfig.txt file
	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftPrintLoggingNormalLogging and "true" or "false"
		file_content = file_content:gsub("LuaCraftPrintLoggingNormal=%w+", "LuaCraftPrintLoggingNormal=" .. printValue)

		-- Rewrite Luacraftconfig.txt file with updated content
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
	_JPROFILER.pop("printNormalLoggingSettings")
end
function printWarnsSettings()
	_JPROFILER.push("printWarnsSettings")
	EnableLuaCraftLoggingWarn = not EnableLuaCraftLoggingWarn
	-- Load current contents of Luacraftconfig.txt file

	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingWarn and "true" or "false"
		file_content = file_content:gsub("LuaCraftWarnLogging=%w+", "LuaCraftWarnLogging=" .. printValue)

		-- Rewrite Luacraftconfig.txt file with updated content
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
	_JPROFILER.pop("printWarnsSettings")
end
function printErrorsSettings()
	_JPROFILER.push("printErrorsSettings")

	EnableLuaCraftLoggingError = not EnableLuaCraftLoggingError

	-- Load current contents of Luacraftconfig.txt file

	local file_content, error_message = customReadFile(Luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingError and "true" or "false"
		file_content = file_content:gsub("LuaCraftErrorLogging=%w+", "LuaCraftErrorLogging=" .. printValue)

		-- Rewrite Luacraftconfig.txt file with updated content
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
	_JPROFILER.pop("printErrorsSettings")
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
		globalRenderDistance = tonumber(renderdistanceValue)
	else
		LuaCraftErrorLogging("Failed to read Luacraftconfig.txt. Error: " .. error_message)
	end

	_JPROFILER.pop("SettingsHandlingInit")
end
