require("src/client/huds/drawhud")
require("src/client/huds/tests/drawhudtest")
function DrawGame()
	setFont()
	LuaCraftCurrentGameState:draw()
end
