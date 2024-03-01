populateChunkModLoader = {}
function addFunctionToTag(tag, func)
	if not populateChunkModLoader[tag] then
		populateChunkModLoader[tag] = {}
	end
	table.insert(populateChunkModLoader[tag], func)
end
function LoadMods()
	-- ModsRequireIteration
	-- Specify the path to the mods directory
	local modsDirectory = "mods/"

	-- Print debugging information
	LuaCraftPrintLoggingNormal("Checking mods directory:", modsDirectory)

	-- Iterate over all items in the mods directory
	local items = lovefilesystem.getDirectoryItems(modsDirectory)
	for _, item in ipairs(items) do
        local fullPath = modsDirectory .. item

        if lovefilesystem.getInfo(fullPath, "directory") then
            local modName = item
            LuaCraftPrintLoggingNormal("Attempting to load mod:", modName)

            -- Get the start time
            local startTime = os.clock()

            -- Load the mod
            local success, mod = pcall(require, "mods." .. modName .. "." .. modName)

            -- Check if the mod loaded successfully
            if success then
                LuaCraftPrintLoggingNormal("Mod loaded successfully:", modName)
                -- Assuming the mod has an initialization function
                if mod.initialize then
                    mod.initialize()
                end

                -- Get the end time after initialization
                local endTime = os.clock()

                -- Calculate the load time
                local loadTime = endTime - startTime

                -- Print the load time
                LuaCraftPrintLoggingNormal("Load time for", modName, ":", loadTime, "seconds")
            else
                LuaCraftPrintLoggingNormal("Failed to load mod:", modName)
                LuaCraftPrintLoggingNormal("Error:", mod)
            end
        end
    end
end
