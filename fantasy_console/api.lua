--[[
This file defines all elements of API that user can use
in their game.
All functions are provided as global functions to give
the feeling of using some kind of console – I wanted to avoid
requiring user to write repeatedly module name over and over.
]]--


local gamepixel = require "gamepixel"
local g = require "globals"
local palette = require "palette"
local sprite = require "sprite"
local utils = require "utils"


------------------
---------- TEXT --
------------------


function Write(s, x, y, color)
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
        Text to be printed. Must be a valid ASCII string.
    x : number
        Position of text beginning at the x axis.
    y : number
        Position of text beginning at the y axis.
    color : palette.<color>
        Color of text. Defaults to the default foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(s) == "string", "First argument (s) to Write must be a valid ASCII string.")
    assert(type(x) == "number", "Second argument (x) to Write must be a number.")
    assert(x >= 0, "Second argument (x) to Write must not be negative.")
    assert(type(y) == "number", "Third argument (y) to Write must be a number.")
    assert(y >= 0, "Third argument (y) to Write must not be negative.")
    assert(utils.check_if_string_is_valid_ascii(s), "First argument (s) to Write must be a valid ASCII string.")

    local lx = math.floor(x * g.screen.gamepixel.w)
    local ly = math.floor(y * g.screen.gamepixel.h)
    if not color then color = g.colors.default_fg_color.rgb01 end
    love.graphics.setColor(unpack(color))
    love.graphics.print(s, lx, ly, 0, 1, 1, 0, 0)
    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
end


function Join(ss, delimiter)
    --[[
    Function Join joins multiple strings into single string.
    It is provided to make joining larger amount of strings into
    single string easier than by using `..` operator.

    Arguments
    ---------
    ss : array of strings
        Single table with all ASCII strings to be joined, e.g.
        {"text1", "text2"}
    delimiter : string = ""
        Optional argument. It specifies what symbol or text will
        be added between strings joined. Defaults to empty string.
    
    Returns
    -------
    string
    ]]--

    assert(type(ss) == "table", "First argument (ss) to Join must be a table.")
    for _, element in ipairs(ss) do
        assert(type(element) == "string", "Every element of table passed to Join must be a valid ASCII string.")
        assert(utils.check_if_string_is_valid_ascii(element), "Every element of table passed to Join must be a valid ASCII string.")
    end

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
        Text to be split. Must be a valid ASCII string.
    delimiter : string = " "
        Delimiter used to split the string. Defaults to space.
    
    Returns
    -------
    {strings}
    ]]--

    assert(type(s) == "string", "First argument (s) passed to Split must be a string.")
    assert(utils.check_if_string_is_valid_ascii(s), "First argument (s) passed to Split must be a valid ASCII string.")
    if delimiter then
        assert(type(delimiter) == "string", "If second argument (delimiter) is passed to Split, it must be a string.")
    end

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
    Function Sub takes string, first index, and second index.
    Previously this function has been using a third-party
    implementation of substring functionality provided by
    stringEx library, but since I dropped support for unicode, it
    is not necessary and I can rely on the Lua standard library.

    Arguments
    ---------
    s : string
        Base string. Must be a valid ASCII string.
    i : number
        Start of the substring (i included).
    j : number
        End of the substring (j included). Must be positive.
    
    Returns
    -------
    string
    ]]--

    assert(type(s) == "string", "First argument (s) passed to Sub must be a valid ASCII string.")
    assert(utils.check_if_string_is_valid_ascii(s), "First argument (s) passed to Sub must be a valid ASCII string.")

    if j < 1 then
        j = i
    end

    local result = string.sub(s, math.floor(i), math.floor(j))
    return result
end


--------------------
---------- SCREEN --
--------------------

function Cls()
    --[[
    Function Cls clears the whole game screen.

    Arguments
    ---------
    none are passed

    Returns
    -------
    nothing
    ]]--

    love.graphics.clear(g.colors.default_bg_color.rgb01)
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
        Color of pixel to-bo-created. Defaults to the default
        foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Pset must be a number.")
    assert(x >= 0, "First argument (x) to Pset must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Pset must be a number.")
    assert(y >= 0, "Second argument (y) to Pset must not be negative.")

    local lx = math.floor(x * g.screen.gamepixel.w)
    local ly = math.floor(y * g.screen.gamepixel.h)
    if not color then color = g.colors.default_fg_color.rgb01 end
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
        "fill",
        lx,
        ly,
        g.screen.gamepixel.w,
        g.screen.gamepixel.h
    )
    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
end


function Line(sx, sy, tx, ty, color)
    -- This is a translation of bresenham algorithm by Petr Viktorin,
    -- written in Python, released under the MIT license.
    -- It's available at https://github.com/encukou/bresenham as of
    -- 20240521
    --[[
Copyright © 2016 Petr Viktorin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
    ]]--

    --[[
    Arguments
    ---------
    sx : number
        Position of the starting point on the x axis.
    sy : number
        Position of the starting point on the y axis.
    tx : number
        Position of the end point on the x axis.
    ty : number
        Position of the end point on the y axis.
    color : palette.<color>
        Color of line to-bo-created. Defaults to the default
        foreground colour.

    Returns
    -------
    nothing
    ]]--

    assert(type(sx) == "number", "First argument (sx) to Line must be a number.")
    assert(sx >= 0, "First argument (sx) to Line must not be negative.")
    assert(type(sy) == "number", "Second argument (sy) to Line must be a number.")
    assert(sy >= 0, "Second argument (sy) to Line must not be negative.")
    assert(type(tx) == "number", "Third argument (tx) to Line must be a number.")
    assert(tx >= 0, "Third argument (tx) to Line must not be negative.")
    assert(type(ty) == "number", "Fourth argument (ty) to Line must be a number.")
    assert(ty >= 0, "Fourth argument (ty) to Line must not be negative.")

    if not color then color = g.colors.default_fg_color.rgb01 end

    sx = math.floor(sx)
    sy = math.floor(sy)
    tx = math.floor(tx)
    ty = math.floor(ty)

    local dx = tx - sx
    local dy = ty - sy

    local xsign = 1
    if dx <= 0 then
        xsign = -1
    end

    local ysign = 1
    if dy <= 0 then
        ysign = -1
    end

    dx = math.abs(dx)
    dy = math.abs(dy)

    local xx = xsign
    local xy = 0
    local yx = 0
    local yy = ysign
    if dx <= dy then
        dx, dy = dy, dx
        xx = 0
        xy = ysign
        yx = xsign
        yy = 0
    end

    local d = 2 * dy - dx
    local y = 0

    for x = 0, dx do
        local coord = {}
        coord.x = sx + x * xx + y * yx
        coord.y = sy + x * xy + y * yy
        Pset(coord.x, coord.y, color)
        if d >= 0 then
            y = y + 1
            d = d - 2 * dx
        end
        d = d + 2 * dy
    end
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
        Color of pixel to-bo-created. Defaults to the default
        foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Rect must be a number.")
    assert(x >= 0, "First argument (x) to Rect must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Rect must be a number.")
    assert(y >= 0, "Second argument (y) to Rect must not be negative.")
    assert(type(w) == "number", "Third argument (w) to Rect must be a number.")
    assert(w > 1, "Third argument (w) to Rect must be larger than 1.")
    assert(type(h) == "number", "Fourth argument (h) to Rect must be a number.")
    assert(h > 1, "Fourth argument (h) to Rect must be larger than 1.")

    local lx = (x * g.screen.gamepixel.w) + (g.screen.gamepixel.w / 2)
    local ly = (y * g.screen.gamepixel.h) + (g.screen.gamepixel.h / 2)
    local lw = (w - 1) * g.screen.gamepixel.w
    local lh = (h - 1) * g.screen.gamepixel.h

    if not color then color = g.colors.default_fg_color.rgb01 end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("line", lx, ly, lw, lh)
    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
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
        Color of pixel to-bo-created. Defaults to the default foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Rectfill must be a number.")
    assert(x >= 0, "First argument (x) to Rectfill must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Rectfill must be a number.")
    assert(y >= 0, "Second argument (y) to Rectfill must not be negative.")
    assert(type(w) == "number", "Third argument (w) to Rectfill must be a number.")
    assert(w > 1, "Third argument (w) to Rectfill must be larger than 1.")
    assert(type(h) == "number", "Fourth argument (h) to Rectfill must be a number.")
    assert(h > 1, "Fourth argument (h) to Rectfill must be larger than 1.")

    local lx = math.floor(x * g.screen.gamepixel.w)
    local ly = math.floor(y * g.screen.gamepixel.h)
    local lw = math.floor(w * g.screen.gamepixel.w)
    local lh = math.floor(h * g.screen.gamepixel.h)

    if not color then color = g.colors.default_fg_color.rgb01 end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", lx, ly, lw, lh)
    love.graphics.setColor(unpack(g.colors.default_fg_color.rgb01))
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
        Color of circle. Defaults to the default foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Circ must be a number.")
    assert(x >= 0, "First argument (x) to Circ must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Circ must be a number.")
    assert(y >= 0, "Second argument (y) to Circ must not be negative.")
    assert(type(r) == "number", "Third argument (r) to Circ must be a number.")
    assert(r > 0, "Third argument (r) to Circ must be larger than 0.")

    x = math.floor(x)
    y = math.floor(y)
    r = math.floor(r)

    if not color then color = g.colors.default_fg_color.rgb01 end

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
        Color of circle. Defaults to the default foreground colour.
    
    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Circfill must be a number.")
    assert(x >= 0, "First argument (x) to Circfill must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Circfill must be a number.")
    assert(y >= 0, "Second argument (y) to Circfill must not be negative.")
    assert(type(r) == "number", "Third argument (r) to Circfill must be a number.")
    assert(r > 0, "Third argument (r) to Circfill must be larger than 0.")

    x = math.floor(x)
    y = math.floor(y)
    r = math.floor(r)

    if not color then color = g.colors.default_fg_color.rgb01 end

    for ty=-r,r do
        for tx=-r,r do
            if(tx*tx+ty*ty <= r*r) then
                Pset(x + tx, y + ty, color)
            end
        end
    end
    Circ(x, y, r, color)
end


function Oval(x, y, rx, ry, color)
    --[[
    Function Oval draws empty (ie not filled) ellipse on the screen.
    It uses midpoint ellipse algorithm.

    Arguments
    ---------
    x : number
        Position of ellipse center on the x axis.
    y : number
        Position of ellipse center on the y axis.
    rx : number
        Length of radius on the x axis.
    ry : number
        Length of radius on the y axis.
    color : palette.<color>
        Color of ellipse. Defaults to the default foreground colour.
    ]]--

    assert(type(x) == "number", "First argument (x) to Oval must be a number.")
    assert(x >= 0, "First argument (x) to Oval must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Oval must be a number.")
    assert(y >= 0, "Second argument (y) to Oval must not be negative.")
    assert(type(rx) == "number", "Third argument (rx) to Oval must be a number.")
    assert(rx > 0, "Third argument (rx) to Oval must be larger than 0.")
    assert(type(ry) == "number", "Fourth argument (ry) to Oval must be a number.")
    assert(ry > 0, "Fourth argument (ry) to Oval must be larger than 0.")

    x = math.floor(x)
    y = math.floor(y)
    rx = math.floor(rx)
    ry = math.floor(ry)

    if not color then color = g.colors.default_fg_color.rgb01 end

    local dx, dy, d1, d2
    local xx = 0;
    local yy = ry;
    d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
    dx = 2 * ry * ry * xx
    dy = 2 * rx * rx * yy

    while (dx < dy) do	
        Pset(xx + x, yy + y, color)
        Pset(-xx + x, yy + y, color)
        Pset(xx + x, -yy + y, color)
        Pset(-xx + x, -yy + y, color)
        if d1 < 0 then
            xx = xx + 1
            dx = dx + (2 * ry * ry)
            d1 = d1 + dx + (ry * ry)
        else
            xx = xx + 1
            yy = yy - 1
            dx = dx + (2 * ry * ry)
            dy = dy - (2 * rx * rx)
            d1 = d1 + dx - dy + (ry * ry)
        end
    end

    d2 = ((ry * ry) * ((xx + 0.5) * (xx + 0.5))) + ((rx * rx) * ((yy - 1) * (yy - 1))) - (rx * rx * ry * ry)
    while (yy >= 0) do	
        Pset(xx + x, yy + y, color)
        Pset(-xx + x, yy + y, color)
        Pset(xx + x, -yy + y, color)
        Pset(-xx + x, -yy + y, color)	
        if d2 > 0 then
            yy = yy - 1
            dy = dy - (2 * rx * rx)
            d2 = d2 + (rx * rx) - dy
        else
            yy = yy - 1
            xx = xx + 1
            dx = dx + (2 * ry * ry)
            dy = dy - (2 * rx * rx)
            d2 = d2 + dx - dy + (rx * rx)
        end
    end
end


function Ovalfill(x, y, rx, ry, color)
    --[[
    Function Ovalfill draws filled ellipse on the screen.
    It uses slightly modified midpoint ellipse algorithm.

    Arguments
    ---------
    x : number
        Position of ellipse center on the x axis.
    y : number
        Position of ellipse center on the y axis.
    rx : number
        Length of radius on the x axis.
    ry : number
        Length of radius on the y axis.
    color : palette.<color>
        Color of ellipse. Defaults to the default foreground colour.
    ]]--

    assert(type(x) == "number", "First argument (x) to Ovalfill must be a number.")
    assert(x >= 0, "First argument (x) to Ovalfill must not be negative.")
    assert(type(y) == "number", "Second argument (y) to Ovalfill must be a number.")
    assert(y >= 0, "Second argument (y) to Ovalfill must not be negative.")
    assert(type(rx) == "number", "Third argument (rx) to Ovalfill must be a number.")
    assert(rx > 0, "Third argument (rx) to Ovalfill must be larger than 0.")
    assert(type(ry) == "number", "Fourth argument (ry) to Ovalfill must be a number.")
    assert(ry > 0, "Fourth argument (ry) to Ovalfill must be larger than 0.")

    x = math.floor(x)
    y = math.floor(y)
    rx = math.floor(rx)
    ry = math.floor(ry)

    if not color then color = g.colors.default_fg_color.rgb01 end

    local dx, dy, d1, d2
    local xx = 0;
    local yy = ry;
    d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
    dx = 2 * ry * ry * xx
    dy = 2 * rx * rx * yy

    while (dx < dy) do
        Line(x - xx, y + yy, x + xx, y + yy, color)
        Line(x - xx, y - yy, x + xx, y - yy, color)
        if d1 < 0 then
            xx = xx + 1
            dx = dx + (2 * ry * ry)
            d1 = d1 + dx + (ry * ry)
        else
            xx = xx + 1
            yy = yy - 1
            dx = dx + (2 * ry * ry)
            dy = dy - (2 * rx * rx)
            d1 = d1 + dx - dy + (ry * ry)
        end
    end

    d2 = ((ry * ry) * ((xx + 0.5) * (xx + 0.5))) + ((rx * rx) * ((yy - 1) * (yy - 1))) - (rx * rx * ry * ry)
    while (yy >= 0) do
        Line(x - xx, y + yy, x + xx, y + yy, color)
        Line(x - xx, y - yy, x + xx, y - yy, color)
        if d2 > 0 then
            yy = yy - 1
            dy = dy - (2 * rx * rx)
            d2 = d2 + (rx * rx) - dy
        else
            yy = yy - 1
            xx = xx + 1
            dx = dx + (2 * ry * ry)
            dy = dy - (2 * rx * rx)
            d2 = d2 + dx - dy + (rx * rx)
        end
    end
end


----------------------
---------- SPRITES --
----------------------


function Spr(num, x, y)
    --[[
    Function Spr allows to draw a sprite on on the specific coordinates.
    Please note that this function, unlike its equivalent from PICO-8,
    does not allow to specify a range of sprites to draw.

    Arguments
    ---------
    num : number
        Number of sprite in the spreadsheet. You should be able to
        determine sprite number looking at the GUI of the sprites
        editor.
    
    x : number
        Position of top-left sprite corner on the x axis.
    y : number
        Position of top-left sprite corner on the y axis.

    Returns
    -------
    nothing
    ]]--

    assert(type(num) == "number", "First argument (num) to Spr must be a number.")
    assert(num > 0, "First argument (num) to Spr must be a number larger than 0.")
    assert(num <= g.sprites_amount, "First argument (num) to Spr must be a number not larger than " .. g.sprites_amount .. ".")
    assert(type(x) == "number", "Second argument (x) to Spr must be a number.")
    assert(x >= 0, "Second argument (x) to Spr must not be negative.")
    assert(type(y) == "number", "Third argument (y) to Spr must be a number.")
    assert(y >= 0, "Third argument (y) to Spr must not be negative.")

    local current_sprite = sprite.get_sprite(num)
    local colors = current_sprite["colors"]
    local nx = x
    local ny = y
	for _, color in pairs(colors) do
		for _, v in pairs(color) do
			-- row
			for k, d in pairs(v) do
				if k == "hex" then
					Pset(nx, ny, palette.find_color_by_hex(d).rgb01)
				end
			end
            nx = nx + 1
		end
        ny = ny + 1
        nx = x
		--color
	end
end


-------------------
---------- INPUT --
-------------------


function Btn(button)
    --[[
    Function Btnp sets repeat mode to true, then checks,
    if button passed as argument is down.

    Arguments
    ---------
    button : Love2d.KeyConstant
        Should be valid KeyConstant value provided by Love2D.

    Returns
    -------
    boolean
        True if button passed as argument is pressed, false otherwise.
    ]]--

    Brpt(true)
    return love.keyboard.isDown(button)
end


function Btnp(button)
    --[[
    Function Btnp sets repeat mode to false, then checks,
    if button passed as argument is down.

    Arguments
    ---------
    button : Love2d.KeyConstant
        Should be valid KeyConstant value provided by Love2D.

    Returns
    -------
    boolean
        True if button passed as argument is pressed, false otherwise.
    ]]--

    Brpt(false)
    return love.keyboard.isDown(button)
end


function Brpt(enabled)
    --[[
    Function Brpt allows to manually set key repeat mode to
    `true` (repeating keypress on hold enabled) or `false`
    (repeating keypress on hold disabled).

    Arguments
    ---------
    enabled : boolean
        Enables or disabled repeat-key-on-hold. It is passed to the
        Love2D function.

    Returns
    -------
    nothing
    ]]--

    assert(type(enabled) == "boolean", "First argument (enabled) to Brpt must be boolean value.")

    love.keyboard.setKeyRepeat(enabled)
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
