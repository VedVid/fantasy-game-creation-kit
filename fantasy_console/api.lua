--[[
This file defines all elements of API that user can use
in their game.
All functions are provided as global functions to give
the feeling of using some kind of console – I wanted to avoid
requiring user to write repeatedly module name over and over.
]]--


local usub = require "stringEx"

local gamepixel = require "gamepixel"
local g = require "globals"
local palette = require "palette"


------------------
---------- TEXT --
------------------


function Write(s, x, y)
    --[[
    Function Write uses the Love2D's print function under the
    hood, but it does not expose all of its arguments to the
    user. 
    Rotation, scaling, and offset are set to the Love2D's
    defaults.

    Currently coords are passed 1:1 because pixel scaling
    is not implemented yet.

    Arguments
    ---------
    s : string
        Text to be printed.
    x : number
        Position of text beginning at the x axis.
    y : number
        Position of text beginning at the y axis.
    
    Returns
    -------
    nothing
    ]]--

    local lx = x * g.screen.gamepixel.w
    local ly = y * g.screen.gamepixel.h
    love.graphics.print(s, lx, ly, 0, 1, 1, 0, 0)
end


function Join(ss, delimiter)
    --[[
    Function Join joins multiple strings into single string.
    It is provided to make joining larger amount of strings into
    single string easier than by using `..` operator.

    Arguments
    ---------
    ss : array of strings
        Single table with all strings to be joined, e.g.
        {"text1", "text2"}
    delimiter : string = ""
        Optional argument. It specifies what symbol or text will
        be added between strings joined. Defaults to empty string.
    
    Returns
    -------
    string
    ]]--

    if not delimiter then
        delimiter = ""
    end
    local s = table.concat(ss, delimiter)
    return s
end


function Split(s, delimiter)
    --[[
    Function Split takes single string and delimiter as arguments,
    and tries to split the string on delimiter.
    If delimiter is not provided, it defaults to single space.
    If delimiter is set to empty string, this function returns the
    string passed without changes.

    Arguments
    ---------
    s : string
        Text to be split.
    delimiter : string = " "
        Delimiter used to split the string.
    
    Returns
    -------
    {strings}
    ]]--

    if delimiter == "" then
        return {s}
    end
    if not delimiter then
        delimiter = " "
    end

    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


function Sub(s, i, j)
    --[[
    Function Sub uses a third-party implementation of "usub" string
    method, provided by stringEx library by losttoken. It is
    released under the terms of MIT license.

    Please see license at the top of stringEx.lua file.

    https://github.com/losttoken/lua-utf8-string
    accessed 20240506

    Unfortunately, this function can not be easily tested with
    standalone Lua interpreter, because:
    - Love2D uses LuaJIT
    - LuaJIT does not provide binaries
    - LuaJIT is compatible with Lua 5.1 and not with Lua 5.3
    - Lua 5.1 does not support UTF-8

    I am not sure if I like how j smaller than 1 is handled
    (here, in Sub function, not in the stringEx library),
    but first of all I do not want this function to simply crash
    on users.

    Arguments
    ---------
    s : string
        Base string.
    i : number
        Start of the substring (i included).
    j : number
        End of the substring (j included). Must be positive.
    
    Returns
    -------
    string
    ]]--

    if j < 1 then
        j = i
    end

    local result = string.usub(s, i, j)
    return result
end


----------------------
---------- GEOMETRY --
----------------------


function Pset(x, y, color)
    --[[
    Function Pset draws new pixel on screen. It does not
    use gamepixel under the hood – user just specifies coordinates
    and color of pixel.

    Arguments
    ---------
    x : number
        Position of pixel on horizontal axis.
    y : number
        Position of pixel on vertical axis.
    color : palette.<color>
        Color of pixel to-bo-created.
    
    Returns
    -------
    nothing
    ]]--

    local lx = x * g.screen.gamepixel.w
    local ly = y * g.screen.gamepixel.h
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
        "fill",
        lx,
        ly,
        g.screen.gamepixel.w,
        g.screen.gamepixel.h
    )
    love.graphics.setColor(unpack(palette.white_bold.rgb01))
end


function Ppset(gamepixel)
    --[[
    Function Pset creates new gamepixel and draws it on screen.

    Arguments
    ---------
    gamepixel : gamepixel
        Gamepixel instance. It encapsulates coordinates and color.
    
    Returns
    -------
    nothing
    ]]--

    love.graphics.setColor(unpack(gamepixel.color.rgb01))
    love.graphics.rectangle(
        "fill",
        gamepixel.x * g.screen.gamepixel.w,
        gamepixel.y * g.screen.gamepixel.h,
        g.screen.gamepixel.w,
        g.screen.gamepixel.h
    )
    love.graphics.setColor(unpack(palette.white_bold.rgb01))
end


function Rect(x, y, w, h, color)
    --[[
    Function Rect creates empty (ie not filled) rectangle on screen.
    lx, ly are increased by half of the current gamepixel due the
    three reasons:
    - by default, Love2D starts drawing in the middle of the pixel,
        which mights result in blurry lines unless we pass 0.5 to
        x and y all the time (not feasible with current app architecture)
        or unless we use "rough" line style (which we use);
    - rough line style rounds the half-pixel which mights cause
        off-by-one issues;
    - setting wide line width cause the line to grow in both directions.
    lw, lh are decreased by single gamepixel because Love2D does
    not take into account the starting point when calculating size
    of rectangle.

    Arguments
    ---------
    x : number
        Position of top-left rectangle corner on the x axis.
    y : number
        Position of top-left rectangle corner on the y axis.
    w : number
        Width of rectangle.
    h : number
        Height of rectangle.
    color : palette.<color>
        Color of pixel to-bo-created.
    
    Returns
    -------
    nothing
    ]]--

    local lx = (x * g.screen.gamepixel.w) + (g.screen.gamepixel.w / 2)
    local ly = (y * g.screen.gamepixel.h) + (g.screen.gamepixel.h / 2)
    local lw = (w - 1) * g.screen.gamepixel.w
    local lh = (h - 1) * g.screen.gamepixel.h
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("line", lx, ly, lw, lh)
    love.graphics.setColor(unpack(palette.white_bold.rgb01))
end


function Rectfill(x, y, w, h, color)
    --[[
    Function Rectfill drawn filled rectangle on the screen.
    `rectangle("line")` and `recangle("filled")` works a bit differently
    in Love2D.
    Rectfill does not require taking into account line width set in
    Love2D, hence the Rectfill implementation is simpler than the Rect one.

    Arguments
    ---------
    x : number
        Position of top-left rectangle corner on the x axis.
    y : number
        Position of top-left rectangle corner on the y axis.
    w : number
        Width of rectangle.
    h : number
        Height of rectangle.
    color : palette.<color>
        Color of pixel to-bo-created.
    
    Returns
    -------
    nothing
    ]]--

    local lx = x * g.screen.gamepixel.w
    local ly = y * g.screen.gamepixel.h
    local lw = w * g.screen.gamepixel.w
    local lh = h * g.screen.gamepixel.h
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", lx, ly, lw, lh)
    love.graphics.setColor(unpack(palette.white_bold.rgb01))
end


function Circ(x, y, r, color)
    --[[
    Function Circ creates empty (ie not filled) circle on the screen.
    It uses midpoint circle alogrithm. 

    Arguments
    ---------
    x : number
        Position of circle center on the x axis.
    y : number
        Position of circle center on the y axis.
    r : number
        Radius.
    color : palette.<color>
        Color of circle.
    
    Returns
    -------
    nothing
    ]]--

    local dx = r
    local dy = 0
    local err = 1 - r
    while dx >= dy do
        Pset(x + dx, y + dy, color)
        Pset(x - dx, y + dy, color)
        Pset(x + dx, y - dy, color)
        Pset(x - dx, y - dy, color)
        Pset(x + dy, y + dx, color)
        Pset(x - dy, y + dx, color)
        Pset(x + dy, y - dx, color)
        Pset(x - dy, y - dx, color)
        dy = dy + 1
        if err < 0 then
            err = err + 2 * dy + 1
        else
            dx = dx - 1
            err = err + 2 * (dy - dx) + 1
        end
    end
end


function Circfill(x, y, r, color)
    --[[
    Function Circfill draws filled circle on the screen. 
    It reuses Circ function for the borders, and brute-forces the coloring.
    
    Arguments
    ---------
    x : number
        Position of circle center on the x axis.
    y : number
        Position of circle center on the y axis.
    r : number
        Radius.
    color : palette.<color>
        Color of circle.
    
    Returns
    -------
    nothing
    ]]--

    for ty=-r,r do
        for tx=-r,r do
            if(tx*tx+ty*ty <= r*r) then
                Pset(x + tx, y + ty, color)
            end
        end
    end
    Circ(x, y, r, color)
end


function Oval(rx, ry, xc, yc, color)
	local dx, dy, d1, d2, x, y
	x = 0;
	y = ry;
	
	d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
	dx = 2 * ry * ry * x
	dy = 2 * rx * rx * y
	
	while (dx < dy) do
		
        Pset(x + xc, y + yc, color)
        Pset(-x + xc, y + yc, color)
        Pset(x + xc, -y + yc, color)
        Pset(-x + xc, -y + yc, color)

		if d1 < 0 then
			x = x + 1
			dx = dx + (2 * ry * ry)
			d1 = d1 + dx + (ry * ry)
		else
			x = x + 1
			y = y - 1
			dx = dx + (2 * ry * ry)
			dy = dy - (2 * rx * rx)
			d1 = d1 + dx - dy + (ry * ry)
		end
	end
	
	d2 = ((ry * ry) * ((x + 0.5) * (x + 0.5))) + ((rx * rx) * ((y - 1) * (y - 1))) - (rx * rx * ry * ry)
	
	while (y >= 0) do
		
        Pset(x + xc, y + yc, color)
        Pset(-x + xc, y + yc, color)
        Pset(x + xc, -y + yc, color)
        Pset(-x + xc, -y + yc, color)
		
		if d2 > 0 then
			y = y - 1
			dy = dy - (2 * rx * rx)
			d2 = d2 + (rx * rx) - dy
		else
			y = y - 1
			x = x + 1
			dx = dx + (2 * ry * ry)
			dy = dy - (2 * rx * rx)
			d2 = d2 + dx - dy + (rx * rx)
		end
	end
end


--------------------
---------- COLORS --
--------------------


Black = palette.black.rgb01
BlackBold = palette.black_bold.rgb01
Blue = palette.blue.rgb01
BlueBold = palette.blue_bold.rgb01
Cyan = palette.cyan.rgb01
CyanBold = palette.cyan_bold.rgb01
Green = palette.green.rgb01
GreenBold = palette.green_bold.rgb01
Pink = palette.magenta.rgb01
PinkBold = palette.magenta_bold.rgb01
Red = palette.red.rgb01
RedBold = palette.red_bold.rgb01
Yellow = palette.yellow.rgb01
YellowBold = palette.yellow_bold.rgb01
White = palette.white.rgb01
WhiteBold = palette.white_bold.rgb01
