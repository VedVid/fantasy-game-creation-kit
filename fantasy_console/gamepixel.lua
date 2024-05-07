local palette = require "palette"


local gamepixel = {}


gamepixel.default_color = palette.black


function gamepixel.new_pixel(x, y, color)
    local new_gamepixel = {}
    new_gamepixel.x = x
    if new_gamepixel.x == nil then
        new_gamepixel.x = 1
    end
    new_gamepixel.y = y
    if new_gamepixel.y == nil then
        new_gamepixel.y = 1
    end
    new_gamepixel.color = color
    if new_gamepixel.color == nil then
        new_gamepixel.color = gamepixel.default_color
    end
    return new_gamepixel
end


return gamepixel
