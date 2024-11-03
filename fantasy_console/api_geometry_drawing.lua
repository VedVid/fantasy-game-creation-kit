local g = require "globals"


-- shortcut for `api_geometry_drawing`
local agd = {}


----------------------
---------- GEOMETRY --
----------------------


function agd.draw_with_pset(coords, color)
    --[[
    This function interates over list of coords and places a single gamepixel
    at every coordinate pair, in color passed as argument.
    It is a fundamental function used for drawing primitives.
    It has to iterate over list of coords because for the most part, we
    do not use Love2D primitives directly; since we need that old-school
    pixelated look.

    Arguments
    ---------
    coords : list of lists of numbers
        List of all coordinates that will be used for drawing. Every
        coordinates pair (x, y) are in separate table.
        `coords` has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    color : palette.<color>
        Color of pixel to-bo-created. Defaults to the default
        foreground colour.

    Returns
    -------
    nothing
    ]]--

    if not color then color = g.colors.default_fg_color.rgb01 end

    local ok, _ = pcall(love.graphics.setColor, unpack(color))
    if not ok then
        ok, _ = pcall(love.graphics.setColor, unpack(color.rgb01))
    end

    for _, v in ipairs(coords) do
        love.graphics.rectangle(
            "fill",
            v.x,
            v.y,
            g.screen.gamepixel.w,
            g.screen.gamepixel.h
        )
    end

    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
end


return agd
