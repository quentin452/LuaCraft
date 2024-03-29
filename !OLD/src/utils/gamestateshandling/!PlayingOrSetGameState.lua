function IsCurrentGameState(state)
	return LuaCraftCurrentGameState == state
end

function SetCurrentGameState(state)
	if LuaCraftCurrentGameState and LuaCraftCurrentGameState.resetMenuSelection then
		LuaCraftCurrentGameState:resetMenuSelection()
	end
	if state == GameStatePlayingGame2 then
		love.mouse.setRelativeMode(true)
		if InitGamePlayingWorld == false then
			GenerateWorld()
			InitGamePlayingWorld = true
		end
	elseif state == GamestateMainMenu2 then
		InitGamePlayingWorld = false
		love.mouse.setRelativeMode(false)
	else
		love.mouse.setRelativeMode(false)
	end
	LuaCraftCurrentGameState = state
	LuaCraftCurrentGameState:resizeMenu()
end
