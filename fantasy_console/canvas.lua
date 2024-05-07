local g = require "globals"

local canvas = {}

canvas.scale_1920x1080 = {}
canvas.scale_1920x1080.gamepixel_w = 5
canvas.scale_1920x1080.gamepixel_h = 5

canvas.scale_1366x768 = {}
canvas.scale_1366x768.gamepixel_w = 3
canvas.scale_1366x768.gamepixel_h = 3

canvas.scale_2560x1440 = {}
canvas.scale_2560x1440.gamepixel_w = 6
canvas.scale_2560x1440.gamepixel_h = 6

canvas.scale_3840x2160 = {}
canvas.scale_3840x2160.gamepixel_w = 9
canvas.scale_3840x2160.gamepixel_h = 9

canvas.default_scale = nil


function canvas.get_player_screen_dimension()
    local _, _, flags = love.window.getMode()
    local _, screen_height = love.window.getDesktopDimensions(flags.displaye)
    if screen_height <= 768 then
        canvas.default_scale = canvas.scale_1366x768
    elseif screen_height <= 1080 then
        canvas.default_scale = canvas.scale_1920x1080
    elseif screen_height <= 1440 then
        canvas.default_scale = canvas.scale_2560x1440
    else
        canvas.default_scale = canvas.scale_3840x2160
    end
end


function canvas.set_global_screen_variables(scale, gamepixel_w, gamepixel_h)
    if scale ~= nil then
        g.screen.gamepixel.w = scale.gamepixel_w
        g.screen.gamepixel.h = scale.gamepixel_h
    elseif gamepixel_h ~= nil and gamepixel_w ~= nil then
        g.screen.gamepixel.w = gamepixel_w
        g.screen.gamepixel.h = gamepixel_h
    else
        error("Error in canvas.set_global_screen_variables:\nscale or (gamepixel_h and gamepixel_h) must be valid value.")
    end
    g.screen.size.pixels.w = g.screen.size.gamepixels.w * g.screen.gamepixel.w
    g.screen.size.pixels.h = g.screen.size.gamepixels.h * g.screen.gamepixel.h
end


function canvas.set_window_size()
    love.window.setMode(g.screen.size.pixels.w, g.screen.size.pixels.h)
end


return canvas
