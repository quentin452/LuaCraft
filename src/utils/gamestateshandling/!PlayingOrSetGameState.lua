function IsCurrentGameState(state)
	return LuaCraftCurrentGameState == state
end

function SetCurrentGameState(state)
	if LuaCraftCurrentGameState and LuaCraftCurrentGameState.resetMenuSelection then
		LuaCraftCurrentGameState:resetMenuSelection()
	end
	LuaCraftCurrentGameState = state
end
