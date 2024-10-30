local g = require "globals"


local canvas = {}


--[[
Below we define the correct scaling
for a few popular screen resolutions.
]]--

canvas.scale_1920x1080 = {}
canvas.scale_1920x1080.gamepixel_w = 5
canvas.scale_1920x1080.gamepixel_h = 5
canvas.scale_1920x1080.font_size = 5*8

canvas.scale_1366x768 = {}
canvas.scale_1366x768.gamepixel_w = 3
canvas.scale_1366x768.gamepixel_h = 3
canvas.scale_1366x768.font_size = 3*8

canvas.scale_2560x1440 = {}
canvas.scale_2560x1440.gamepixel_w = 6
canvas.scale_2560x1440.gamepixel_h = 6
canvas.scale_2560x1440.font_size = 6*8

canvas.scale_3840x2160 = {}
canvas.scale_3840x2160.gamepixel_w = 9
canvas.scale_3840x2160.gamepixel_h = 9
canvas.scale_3840x2160.font_size = 9*8


--[[
At the startup, default scale will be determinated
by checking the monitor dimensions. It will use
one of the scaling modes defined above.
]]
canvas.default_scale = nil


function canvas.get_player_screen_dimension()
    --[[
    This method checks the monitor dimensions, then
    sets the default scale that will be used at the
    beginning of app execution.
    Gamepixel is a fundamental unit that tells how many
    "real" pixels grouped together makes a single in-game
    pixel.

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

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


function canvas.set_global_screen_variables(scale, gamepixel_w, gamepixel_h, font_size)
    --[[
    This method sets global variables that are used by other functions
    to set the size of screen.
    Gamepixel is a fundamental unit that tells how many
    "real" pixels grouped together makes a single in-game
    pixel.
    Font size is the height in pixels (_not_ gamepixels).

    Arguments
    ---------
    scale : table
        Scale is table with width and height of gamepixel.
        It can be nil, if all other arguments are provided.
        Scale has higher priority than other arguments.
    gamepixel_w : number
        Arbitral value of gamepixel width. By convention, gamepixel_w
        is the same value as gamepixel_h, but app does not
        enforce it.
        Can be nil if `scale` argument is provided.
    gamepixel_h : number
        Arbitral value of gamepixel height. By convention, gamepixel_h
        is the same value as gamepixel_w, but app does not
        enforce it.
        Can be nil if `scale` argument is provided.
    font_size : number
        Height of font in pixels.
        Can be nil if `scale` argument is provided.

    Returns
    -------
    nothing
    ]]--

    if scale ~= nil then
        g.screen.gamepixel.w = scale.gamepixel_w
        g.screen.gamepixel.h = scale.gamepixel_h
        g.screen.font_size = scale.font_size
    elseif gamepixel_h ~= nil and gamepixel_w ~= nil and font_size ~= nil then
        g.screen.gamepixel.w = gamepixel_w
        g.screen.gamepixel.h = gamepixel_h
        g.screen.font_size = font_size
    else
        error("Error in canvas.set_global_screen_variables:\nscale or (gamepixel_h and gamepixel_h) must be valid value.")
    end
    g.screen.size.pixels.w = g.screen.size.gamepixels.w * g.screen.gamepixel.w
    g.screen.size.pixels.h = g.screen.size.gamepixels.h * g.screen.gamepixel.h
end


function canvas.scale_up()
    --[[
    This method might be used to scale the gamepixels and, therefore,
    app window, up. It also scales the font size.
    There is no defined upper bound of scaling.

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    canvas.set_global_screen_variables(
        nil,
        g.screen.gamepixel.w + 1,
        g.screen.gamepixel.h + 1,
        g.screen.font_size + g.sprites.size_h
    )
    canvas.set_font()
    canvas.set_line_width()
    canvas.set_window_size()
end


function canvas.scale_down()
    --[[
    This method might be used to scale the gamepixels and, therefore,
    app window, down. It also scales the font size. Font and each
    gamepixel can not be smaller than 1 real pixel.


    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    local new_gamepixel_w = g.screen.gamepixel.w - 1
    local new_gamepixel_h = g.screen.gamepixel.h - 1
    local new_font_size = g.screen.font_size - g.sprites.size_h
    if new_gamepixel_w <= 0 or new_gamepixel_h <= 0 or new_font_size <= 0 then
        return
    end
    canvas.set_global_screen_variables(nil, new_gamepixel_w, new_gamepixel_w, new_font_size)
    canvas.set_font()
    canvas.set_line_width()
    canvas.set_window_size()
end


function canvas.set_font()
    --[[
    This method sets font size taking into account global variables.
    It also sets the filtering to the "nearest" to ensure pixelated
    look.
    In future, it would be good to use this function to set
    totally new font based on otf / ttf / bmp font.

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    g.font = nil
    g.font = love.graphics.newFont(g.font_name, g.screen.font_size)
    g.font:setFilter("nearest")
    love.graphics.setFont(g.font)
end


function canvas.set_line_style()
    love.graphics.setLineStyle("rough")
end


function canvas.set_line_width()
    love.graphics.setLineWidth(
        math.min(
            g.screen.gamepixel.h,
            g.screen.gamepixel.w
        )
    )
end


function canvas.set_window_size()
    --[[
    This method sets window size taking into account global variables.

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    love.window.setMode(g.screen.size.pixels.w, g.screen.size.pixels.h)
end


function canvas.set_background_color()
    --[[
    This method sets the default background color for console.
    It is called once during love.load call, and then on every frame
    at the beginning of love.draw call.

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    love.graphics.clear(g.colors.default_bg_color.rgb01)
end


return canvas
