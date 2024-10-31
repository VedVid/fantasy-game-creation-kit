--[[
This file defines all elements of API that user can use
in their game.
All functions are provided as global functions to give
the feeling of using some kind of console – I wanted to avoid
requiring user to write repeatedly module name over and over.
]]--


local agcalc = require "api_geometry_calculations"
local agdraw = require "api_geometry_drawing"
local g = require "globals"
local palette = require "palette"
local sprite = require "sprite"
local utils = require "utils"


------------------
---------- TEXT --
------------------


function Write(x, y, s, color)
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
    x : number
        Position of text beginning at the x axis.
    y : number
        Position of text beginning at the y axis.
    s : string
        Text to be printed. Must be a valid ASCII string.
    color : palette.<color>
        Color of text. Defaults to the default foreground colour.

    Returns
    -------
    nothing
    ]]--

    assert(x ~= nil, "First argument (x) to Write must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Write must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Write must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Write must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Write must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Write must not be negative. Got " .. tostring(y) .. ".")
    assert(s ~= nil, "Third argument (s) to Write must not be nil. Got nil.")
    assert(type(s) == "string", "Third argument (s) to Write must be a valid ASCII string. Got " .. tostring(s) .. " (type " .. tostring(type(s)) .. ").")
    assert(utils.check_if_string_is_valid_ascii(s), "Third argument (s) to Write must be a valid ASCII string. Got " .. tostring(s) .. ".")

    local lx = math.floor(x * g.screen.gamepixel.w)
    local ly = math.floor(y * g.screen.gamepixel.h)
    if not color then color = g.colors.default_fg_color.rgb01 end
    local ok, _ = pcall(love.graphics.setColor, unpack(color))
    if not ok then
        ok, _ = pcall(love.graphics.setColor, unpack(color.rgb01))
    end
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

    assert(ss ~= nil, "First argument (ss) to Join must not be nil. Got nil.")
    assert(type(ss) == "table", "First argument (ss) to Join must be a table. Got " .. tostring(ss) .. " (type " .. tostring(type(ss)) .. ").")
    for _, element in ipairs(ss) do
        assert(type(element) == "string", "Every element of table passed to Join must be a valid ASCII string. Got " .. tostring(element) .. " (type " .. tostring(type(element)) .. ").")
        assert(utils.check_if_string_is_valid_ascii(element), "Every element of table passed to Join must be a valid ASCII string. Got " .. tostring(element) .. ".")
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

    assert(s ~= nil, "First argument (s) to Split must not be nil. Got nil.")
    assert(type(s) == "string", "First argument (s) passed to Split must be a string. Got " .. tostring(s) .. " (type " .. tostring(type(s)) .. ").")
    assert(utils.check_if_string_is_valid_ascii(s), "First argument (s) passed to Split must be a valid ASCII string. Got " .. tostring(s) .. ".")
    if delimiter then
        assert(type(delimiter) == "string", "If second argument (delimiter) is passed to Split, it must be a string. Got " .. tostring(delimiter) .. ".")
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

    assert(s ~= nil, "First argument (s) to Sub must not be nil. Got nil.")
    assert(type(s) == "string", "First argument (s) passed to Sub must be a valid ASCII string. Got " .. tostring(s) .. " (type " .. tostring(type(s)) .. ").")
    assert(utils.check_if_string_is_valid_ascii(s), "First argument (s) passed to Sub must be a valid ASCII string. Got " .. tostring(s) .. ".")

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

    assert(x ~= nil, "First argument (x) to Pset must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Pset must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Pset must not be negative. Got " .. tostring(x) .. ".")
    assert(type(y) == "number", "Second argument (y) to Pset must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Pset must not be negative. Got " .. tostring(y) .. ".")

    local coords = agcalc.pset(x, y)

    agdraw.draw_with_pset(coords, color)
end


function Line(sx, sy, tx, ty, color)
    --[[
    -- This function draws a line from sx, sy to tx, ty. Under the hood,
    -- it uses translation of bresenham algorithm by Petr Viktorin
    -- written in Python, released under the MIT license.
    -- It's available at https://github.com/encukou/bresenham as of
    -- 20240521
    -- For details, please read the comment to
    -- api_geometry_calculations.line, and to the
    -- `bresenham_by_Petr_Viktoring.txt` file inside `licenses` directory.

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

    assert(sx ~= nil, "First argument (sx) to Line must not be nil. Got nil.")
    assert(type(sx) == "number", "First argument (sx) to Line must be a number. Got " .. tostring(sx) .. " (type " .. tostring(type(sx)) .. ").")
    assert(sx >= 0, "First argument (sx) to Line must not be negative. Got " .. tostring(sx) .. ".")
    assert(sy ~= nil, "Second argument (sy) to Line must not be nil. Got nil.")
    assert(type(sy) == "number", "Second argument (sy) to Line must be a number. Got " .. tostring(sy) .. " (type " .. tostring(type(sy)) .. ").")
    assert(sy >= 0, "Second argument (sy) to Line must not be negative. Got " .. tostring(sy) .. ".")
    assert(tx ~= nil, "Third argument (tx) to Line must not be nil. Got nil.")
    assert(type(tx) == "number", "Third argument (tx) to Line must be a number. Got " .. tostring(tx) .. " (type " .. tostring(type(tx)) .. ").")
    assert(tx >= 0, "Third argument (tx) to Line must not be negative. Got " .. tostring(tx) .. ".")
    assert(ty ~= nil, "Fourth argument (ty) to Line must not be nil. Got nil.")
    assert(type(ty) == "number", "Fourth argument (ty) to Line must be a number. Got " .. tostring(ty) .. " (type " .. tostring(type(ty)) .. ").")
    assert(ty >= 0, "Fourth argument (ty) to Line must not be negative. Got " .. tostring(ty) .. ".")

    local coords = agcalc.line(sx, sy, tx, ty)

    agdraw.draw_with_pset(coords, color)
end


function Rect(x, y, w, h, color)
    --[[
    Function Rect creates empty (ie not filled) rectangle on screen.

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

    assert(x ~= nil, "First argument (x) to Rect must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Rect must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Rect must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Rect must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Rect must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Rect must not be negative. Got " .. tostring(y) .. ".")
    assert(w ~= nil, "Third argument (w) to Rect must not be nil. Got nil.")
    assert(type(w) == "number", "Third argument (w) to Rect must be a number. Got " .. tostring(w) .. " (type " .. tostring(type(w)) .. ").")
    assert(w > 1, "Third argument (w) to Rect must be larger than 1. Got " .. tostring(w) .. ".")
    assert(h ~= nil, "Fourth argument (h) to Rect must not be nil. Got nil.")
    assert(type(h) == "number", "Fourth argument (h) to Rect must be a number. Got " .. tostring(h) .. " (type " .. tostring(type(h)) .. ").")
    assert(h > 1, "Fourth argument (h) to Rect must be larger than 1. Got " .. tostring(h) .. ".")

    local coords = agcalc.rect(x, y, w, h)

    agdraw.draw_with_pset(coords, color)
end


function Rectfill(x, y, w, h, color)
    --[[
    Function Rectfill drawn filled rectangle on the screen.

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

    assert(x ~= nil, "First argument (x) to Rectfill must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Rectfill must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Rectfill must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Rectfill must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Rectfill must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Rectfill must not be negative. Got " .. tostring(y) .. ".")
    assert(w ~= nil, "Third argument (w) to Rectfill must not be nil. Got nil.")
    assert(type(w) == "number", "Third argument (w) to Rectfill must be a number. Got " .. tostring(w) .. " (type " .. tostring(type(w)) .. ").")
    assert(w > 1, "Third argument (w) to Rectfill must be larger than 1. Got " .. tostring(w) .. ".")
    assert(h ~= nil, "Fourth argument (h) to Rectfill must not be nil. Got nil.")
    assert(type(h) == "number", "Fourth argument (h) to Rectfill must be a number. Got " .. tostring(h) .. " (type " .. tostring(type(h)) .. ").")
    assert(h > 1, "Fourth argument (h) to Rectfill must be larger than 1. Got " .. tostring(h) .. ".")

    local coords = agcalc.rectfill(x, y, w, h)

    agdraw.draw_with_pset(coords, color)
end


function Circ(x, y, r, color)
    --[[
    Function Circ creates empty (ie not filled) circle on the screen.
    Under the hood, it uses midpoint circle alogrithm.

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

    assert(x ~= nil, "First argument (x) to Circ must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Circ must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Circ must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Circ must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Circ must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Circ must not be negative. Got " .. tostring(y) .. ".")
    assert(r ~= nil, "Third argument (r) to Circ must not be nil. Got nil.")
    assert(type(r) == "number", "Third argument (r) to Circ must be a number. Got " .. tostring(r) .. " (type " .. tostring(type(r)) .. ").")
    assert(r > 0, "Third argument (r) to Circ must be larger than 0. Got " .. tostring(r) .. ".")

    local coords = agcalc.circ(x, y, r)

    agdraw.draw_with_pset(coords, color)
end


function Circfill(x, y, r, color)
    --[[
    Function Circfill draws filled circle on the screen.
    Under the hood, it uses midpoint circle alogrithm for border,
    then brute-forces the colouring inside the borders.

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

    assert(x ~= nil, "First argument (x) to Circfill must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Circfill must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Circfill must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Circfill must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Circfill must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Circfill must not be negative. Got " .. tostring(y) .. ".")
    assert(r ~= nil, "Third argument (r) to Circfill must not be nil. Got nil.")
    assert(type(r) == "number", "Third argument (r) to Circfill must be a number. Got " .. tostring(r) .. " (type " .. tostring(type(r)) .. ").")
    assert(r > 0, "Third argument (r) to Circfill must be larger than 0. Got " .. tostring(r) .. ".")

    local coords = agcalc.circfill(x, y, r)

    agdraw.draw_with_pset(coords, color)
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

    Returns
    -------
    nothing
    ]]--

    assert(x ~= nil, "First argument (x) to Oval must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Oval must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Oval must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Oval must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Oval must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Oval must not be negative. Got " .. tostring(y) .. ".")
    assert(rx ~= nil, "Third argument (rx) to Oval must not be nil. Got nil.")
    assert(type(rx) == "number", "Third argument (r) to Oval must be a number. Got " .. tostring(rx) .. " (type " .. tostring(type(rx)) .. ").")
    assert(rx > 0, "Third argument (r) to Oval must be larger than 0. Got " .. tostring(rx) .. ".")
    assert(ry ~= nil, "Fourth argument (ry) to Oval must not be nil. Got nil.")
    assert(type(ry) == "number", "Fourth argument (ry) to Oval must be a number. Got " .. tostring(ry) .. " (type " .. tostring(type(ry)) .. ").")
    assert(ry > 0, "Fourth argument (ry) to Oval must be larger than 0. Got " .. tostring(ry) .. ".")

    local coords = agcalc.oval(x, y, rx, ry)

    agdraw.draw_with_pset(coords, color)
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

    Returns
    -------
    nothing
    ]]--

    assert(x ~= nil, "First argument (x) to Ovalfill must not be nil. Got nil.")
    assert(type(x) == "number", "First argument (x) to Ovalfill must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Ovalfill must not be negative. Got " .. tostring(x) .. ".")
    assert(y ~= nil, "Second argument (y) to Ovalfill must not be nil. Got nil.")
    assert(type(y) == "number", "Second argument (y) to Ovalfill must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Ovalfill must not be negative. Got " .. tostring(y) .. ".")
    assert(rx ~= nil, "Third argument (rx) to Ovalfill must not be nil. Got nil.")
    assert(type(rx) == "number", "Third argument (r) to Ovalfill must be a number. Got " .. tostring(rx) .. " (type " .. tostring(type(rx)) .. ").")
    assert(rx > 0, "Third argument (r) to Ovalfill must be larger than 0. Got " .. tostring(rx) .. ".")
    assert(ry ~= nil, "Fourth argument (ry) to Ovalfill must not be nil. Got nil.")
    assert(type(ry) == "number", "Fourth argument (ry) to Ovalfill must be a number. Got " .. tostring(ry) .. " (type " .. tostring(type(ry)) .. ").")
    assert(ry > 0, "Fourth argument (ry) to Ovalfill must be larger than 0. Got " .. tostring(ry) .. ".")

    local coords = agcalc.ovalfill(x, y, rx, ry)

    agdraw.draw_with_pset(coords, color)
end


----------------------
---------- SPRITES --
----------------------


function Spr(x, y, num)
    --[[
    Function Spr allows to draw a sprite on on the specific coordinates.
    Please note that this function, unlike its equivalent from PICO-8,
    does not allow to specify a range of sprites to draw.

    Arguments
    ---------
    x : number
        Position of top-left sprite corner on the x axis.
    y : number
        Position of top-left sprite corner on the y axis.
    num : number
        Number of sprite in the spreadsheet. You should be able to
        determine sprite number looking at the GUI of the sprites
        editor.

    Returns
    -------
    nothing
    ]]--

    assert(type(x) == "number", "First argument (x) to Spr must be a number. Got " .. tostring(x) .. " (type " .. tostring(type(x)) .. ").")
    assert(x >= 0, "First argument (x) to Spr must not be negative. Got " .. tostring(x) .. ".")
    assert(type(y) == "number", "Second argument (y) to Spr must be a number. Got " .. tostring(y) .. " (type " .. tostring(type(y)) .. ").")
    assert(y >= 0, "Second argument (y) to Spr must not be negative. Got " .. tostring(y) .. ".")
    assert(type(num) == "number", "Third argument (num) to Spr must be a number. Got " .. tostring(num) .. " (type " .. tostring(type(num)) .. ").")
    assert(num > 0, "Third argument (num) to Spr must be a number larger than 0. Got " .. tostring(num) .. ".")
    assert(num <= g.sprites.amount, "Third argument (num) to Spr must be a number not larger than " .. tostring(g.sprites.amount) .. ". Got " .. tostring(num) .. ".")

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
