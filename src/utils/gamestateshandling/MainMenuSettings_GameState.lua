--mouseandkeybindlogic.lua
function GamestateMainMenuSettingsMouseAndKeybindLogic(x, y, b)
	if b == 1 then
        local choiceClicked = math.floor((y - _MainMenuSettings.y) / Font25:getHeight("X"))
        if choiceClicked >= 1 and choiceClicked <= #_MainMenuSettings.choice then
            _MainMenuSettings.selection = choiceClicked
            if choiceClicked == 1 then
                LuaCraftSettingsUpdater("toggleVSync")
            elseif choiceClicked == 2 then
                LuaCraftSettingsUpdater("NormalLoggingToggler")
                ThreadLogChannel:supply({ "ResetLoggerKeys", false })
            elseif choiceClicked == 3 then
                LuaCraftSettingsUpdater("WarnLoggingToggler")
                ThreadLogChannel:supply({ "ResetLoggerKeys", false })
            elseif choiceClicked == 4 then
                LuaCraftSettingsUpdater("ErrorLoggingToggler")
                ThreadLogChannel:supply({ "ResetLoggerKeys", false })
            elseif choiceClicked == 5 then
                LuaCraftSettingsUpdater("renderdistanceSetting")
                Renderdistancegetresetted = true
            elseif choiceClicked == 6 then
                if Gamestate == GamestatePlayingGameSettings then
                    Gamestate = GamestateKeybindingPlayingGameSettings
                    _MainMenuSettings.selection = 0
                elseif Gamestate == GamestateMainMenuSettings then
                    Gamestate = GamestateKeybindingMainSettings
                    _MainMenuSettings.selection = 0
                end
                _MainMenuSettings.selection = 0
            elseif choiceClicked == 7 then
                if Gamestate == GamestatePlayingGameSettings then
                    Gamestate = GamestatePlayingGame
                    _MainMenuSettings.selection = 0
                elseif Gamestate == GamestateMainMenuSettings then
                    Gamestate = GamestateMainMenu
                    _MainMenuSettings.selection = 0
                end
            end
        end
    end
end
