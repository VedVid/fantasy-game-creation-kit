local g = require "globals"


-- shortcut for `api_drawing`
local ad = {}


----------------------
---------- GEOMETRY --
----------------------


function ad.draw(coords, color)
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


function ad.draw_rect(coords, color)
    if not color then color = g.colors.default_fg_color.rgb01 end

    local ok, _ = pcall(love.graphics.setColor, unpack(color))
    if not ok then
        ok, _ = pcall(love.graphics.setColor, unpack(color.rgb01))
    end

    love.graphics.rectangle(
        "line",
        coords.lx,
        coords.ly,
        coords.lw, 
        coords.lh
    )
    
    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
end


return ad
