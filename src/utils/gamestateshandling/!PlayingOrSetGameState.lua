--TODO MADE THIS MORE MAINTAINABLE

function IsPlayingGame()
	return LuaCraftCurrentGameState == GameStatePlayingGame2
end
function SetPlayingGame()
	LuaCraftCurrentGameState = GameStatePlayingGame2
end

function IsPlayingGameStateBase()
	return LuaCraftCurrentGameState == GameStateBase
end
function SetPlayingGameStateBase()
	LuaCraftCurrentGameState = GameStateBase
end

function IsPlayingGamestateGamePausing2()
	return LuaCraftCurrentGameState == GamestateGamePausing2
end
function SetPlayingGamestateGamePausing2()
	LuaCraftCurrentGameState = GamestateGamePausing2
end

function IsPlayingGamestateKeybindingMainSettings2()
	return LuaCraftCurrentGameState == GamestateKeybindingMainSettings2
end
function SetPlayingGamestateKeybindingMainSettings2()
	LuaCraftCurrentGameState = GamestateKeybindingMainSettings2
end

function IsPlayingGamestateKeybindingPlayingGameSettings2()
	return LuaCraftCurrentGameState == GamestateKeybindingPlayingGameSettings2
end
function SetPlayingGamestateKeybindingPlayingGameSettings2()
	LuaCraftCurrentGameState = GamestateKeybindingPlayingGameSettings2
end

function IsPlayingGamestateMainMenu2()
	return LuaCraftCurrentGameState == GamestateMainMenu2
end
function SetPlayingGamestateMainMenu2()
	LuaCraftCurrentGameState = GamestateMainMenu2
end

function IsPlayingGamestateMainMenuSettings2()
	return LuaCraftCurrentGameState == GamestateMainMenuSettings2
end
function SetPlayingGamestateMainMenuSettings2()
	LuaCraftCurrentGameState = GamestateMainMenuSettings2
end

function IsPlayingGameStatePlayingGame2()
	return LuaCraftCurrentGameState == GameStatePlayingGame2
end
function SetPlayingGameStatePlayingGame2()
	LuaCraftCurrentGameState = GameStatePlayingGame2
end

function IsPlayingGamestateWorldCreationMenu2()
	return LuaCraftCurrentGameState == GamestateWorldCreationMenu2
end
function SetPlayingGamestateWorldCreationMenu2()
	LuaCraftCurrentGameState = GamestateWorldCreationMenu2
end

function IsPlayingGamestatePlayingGameSettings2()
	return LuaCraftCurrentGameState == GamestatePlayingGameSettings2
end
function SetPlayingGamestatePlayingGameSettings2()
	LuaCraftCurrentGameState = GamestatePlayingGameSettings2
end
