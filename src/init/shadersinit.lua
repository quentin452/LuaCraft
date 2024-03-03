function InitializeShaders()
	-- Shader to change color of crosshair to contrast with what is being looked at
	CrosshairShader = love.graphics.newShader([[
        uniform Image source;
        uniform number xProportion;
        uniform number yProportion;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec2 scaled_coords;
            scaled_coords.x = (texture_coords.x - 0.9375) * 16;
            scaled_coords.y = texture_coords.y * 16;

            vec4 sourcecolor = Texel(source, vec2(0.5 + (-0.5 + scaled_coords.x) * xProportion, 0.5 + (0.5 - scaled_coords.y) * yProportion));
            sourcecolor.rgb = 1.0 - sourcecolor.rgb;

            vec4 crosshair = Texel(texture, texture_coords);
            sourcecolor.a = crosshair.a;

            return sourcecolor;
        }
    ]])
end
