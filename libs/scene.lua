local scene

return function (newscene)
    prof.push("newscene")
    if newscene then
        scene = newscene
        love.audio.stop()
        if scene.init then scene:init() end
        love.timer.step()
    end
	prof.pop("newscene")

    return scene
end
