local scene

return function(newscene)
	_JPROFILER.push("newscene")
	if newscene then
		scene = newscene
		love.audio.stop()
		if scene.init then
			scene:init()
		end
		love.timer.step()
	end
	_JPROFILER.pop("newscene")

	return scene
end
