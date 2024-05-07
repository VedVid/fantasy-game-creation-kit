local palette = require "palette"


local gamepixel = {}


--[[
Screen of the whole app is made from gamepixels.
It serves as fundamental rendering unit, just like normal
pixels on computer.
]]--

gamepixel.default_color = palette.black
gamepixel.x = 1
gamepixel.y = 1
gamepixel.color = gamepixel.default_color


function gamepixel.new_gamepixel(x, y, color)
    --[[
    This method creates new gamepixel, with its own
    coordinates and color.

    Arguments
    ---------
    x : number
        Position of gamepixel on horizontal axis. Defaults to 1.
    y : number
        Position of gamepixel on vertical axis. Defaults to 1.
    color : palette.<color>
        Color of pixel-to-be-created. Currently ignored.
    
    Returns
    -------
    gamepixel
    ]]--

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
