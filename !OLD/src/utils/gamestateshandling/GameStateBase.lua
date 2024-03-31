GameStateBase = {}

function GameStateBase:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function GameStateBase:resizeMenu() end

function GameStateBase:resetMenuSelection() end
function GameStateBase:update(dt) end

function GameStateBase:draw() end

function GameStateBase:mousemoved(x, y, dx, dy) end

function GameStateBase:mousepressed(x, y, b) end

function GameStateBase:textinput(text) end

function GameStateBase:keypressed(k) end

function GameStateBase:resize(w, h) end
function GameStateBase:setFont()
	return Font15
end
