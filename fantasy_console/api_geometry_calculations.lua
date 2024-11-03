local g = require "globals"


-- shortcut for `api_geometry_calculations`
local agc = {}


----------------------
---------- GEOMETRY --
----------------------


function agc.pset(x, y)
    --[[
    This function just translates passed x, y parameters into table of two values.
    It is present mostly to keep things consistent with other functions calculating
    lists of coordinates.

    Arguments
    ---------
    x : number
        Position of pixel on horizontal axis.
    y : number
        Position of pixel on vertical axis.

    Returns
    -------
    list of numbers
        List of coords, in the following form: {x = value_x, y = value_y}
    ]]--

    local coords = {
        {
            x = math.floor(x * g.screen.gamepixel.w),
            y = math.floor(y * g.screen.gamepixel.h)
        }
    }

    return coords
end


function agc.line(sx, sy, tx, ty)
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

    Returns
    -------
    list of lists
        List of coords of all gamepixels that create the line.
        It has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    ]]--

    local coords = {}

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
        local coord = {
            x = (sx + x * xx + y * yx) * g.screen.gamepixel.w,
            y = (sy + x * xy + y * yy) * g.screen.gamepixel.h
        }
        table.insert(coords, coord)
        if d >= 0 then
            y = y + 1
            d = d - 2 * dx
        end
        d = d + 2 * dy
    end

    return coords
end


function agc.rect(x, y, w, h)
    --[[
    This function calculates list of coordinates of all points that create
    an empty rectangle. It uses `agc.line` function to find coordinates of
    two vertical and two horizontal lines.

    Note: rect (and rectfill) functions used to be kind of special case – they were
    not drawn with pset / line or any other function implemented in this engine,
    but instead, they were relying on Love2D's rect drawing. It required some
    special treatment as the behaviour was changing depending on the style used
    (`line` and `fill`). After all, it turned out it is easier to treat rectangles
    as every other geometry primitive present in my API.

    Arguments
    ---------
    x : number
        Position of anchored corner on the x axis.
    y : number
        Position of anchored corner on the y axis.
    w : number
        Width of the rectangle. Can be negative.
    h : number
        Height of the rectangle. Can be negative.

    Returns
    -------
    list of lists
        List of coords of all gamepixels that create the line.
        It has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    ]]--

    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)

    local x2 = x + w
    local y2 = y + h

    local coords = {}

    local xx = {}
    local yy = {}

    if x < x2 then
        xx = {x, x2 - 1}
    else
        xx = {x2, x}
    end

    if y < y2 then
        yy = {y, y2 - 1}
    else
        yy = {y2, y}
    end

    local top = agc.line(xx[1], yy[1], xx[2], yy[1])
    local bottom = agc.line(xx[1], yy[2], xx[2], yy[2])
    local left = agc.line(xx[1], yy[1], xx[1], yy[2])
    local right = agc.line(xx[2], yy[1], xx[2], yy[2])
    local all_lines = {}
    table.insert(all_lines, top)
    table.insert(all_lines, bottom)
    table.insert(all_lines, left)
    table.insert(all_lines, right)

    for _, line in pairs(all_lines) do
        for _, coord in pairs(line) do
            table.insert(coords, coord)
        end
    end

    return coords
end


function agc.rectfill(x, y, w, h)
    --[[
    This function calculates list of coordinates of all points that create
    an filled rectangle. It uses `agc.line` function to find coordinates of every
    point that creates filled rectangle. It does that by kind of slicing rectangle
    into horizontal lines.

    Note: rectfill (and rectf) functions used to be kind of special case – they were
    not drawn with pset / line or any other function implemented in this engine,
    but instead, they were relying on Love2D's rect drawing. It required some
    special treatment as the behaviour was changing depending on the style used
    (`line` and `fill`). After all, it turned out it is easier to treat rectangles
    as every other geometry primitive present in my API.

    Arguments
    ---------
    x : number
        Position of anchored corner on the x axis.
    y : number
        Position of anchored corner on the y axis.
    w : number
        Width of the rectangle. Can be negative.
    h : number
        Height of the rectangle. Can be negative.

    Returns
    -------
    list of lists
        List of coords of all gamepixels that create the line.
        It has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    ]]--

    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)

    local x2 = x + w
    local y2 = y + h

    local xx = {}
    local yy = {}

    if x < x2 then
        xx = {x, x2 - 1}
    else
        xx = {x2, x}
    end

    if y < y2 then
        yy = {y, y2 - 1}
    else
        yy = {y2, y}
    end

    local lines = {}

    for i=yy[1], yy[2] do
        local line = agc.line(xx[1], i, xx[2], i)
        table.insert(lines, line)
    end

    local coords = {}

    for _, line in pairs(lines) do
        for _, coord in pairs(line) do
            table.insert(coords, coord)
        end
    end

    return coords
end


function agc.circ(x, y, r)
    --[[
    This function calculates list of coordinates of all points that create
    an empty circle.
    It uses midpoint circle alogrithm.

    Arguments
    ---------
    x : number
        Position of circle center on the x axis.
    y : number
        Position of circle center on the y axis.
    r : number
        Radius.

    Returns
    -------
    list of lists
        List of coords of all gamepixels that create the line.
        It has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    ]]--

    local coords = {}

    x = math.floor(x)
    y = math.floor(y)
    r = math.floor(r)

    local dx = r
    local dy = 0
    local err = 1 - r
    while dx >= dy do
        table.insert(coords, {
            x = (x + dx) * g.screen.gamepixel.w,
            y = (y + dy) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x - dx) * g.screen.gamepixel.w,
            y = (y + dy) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x + dx) * g.screen.gamepixel.w,
            y = (y - dy) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x - dx) * g.screen.gamepixel.w,
            y = (y - dy) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x + dy) * g.screen.gamepixel.w,
            y = (y + dx) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x - dy) * g.screen.gamepixel.w,
            y = (y + dx) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x + dy) * g.screen.gamepixel.w,
            y = (y - dx) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (x - dy) * g.screen.gamepixel.w,
            y = (y - dx) * g.screen.gamepixel.h
        })
        dy = dy + 1
        if err < 0 then
            err = err + 2 * dy + 1
        else
            dx = dx - 1
            err = err + 2 * (dy - dx) + 1
        end
    end

    return coords
end


function agc.circfill(x, y, r)
    --[[
    This function calculates list of coordinates of all points that create
    a filled circle.
    It re-uses circ function, and brute-forces the filling.

    Arguments
    ---------
    x : number
        Position of circle center on the x axis.
    y : number
        Position of circle center on the y axis.
    r : number
        Radius.

    Returns
    -------
    list of lists
        List of coords of all gamepixels that create the line.
        It has the following structure:
        { {x1, y1}, {x2, y2}, ... {xn, yn} }
    ]]--

    -- Start by adding coords of circle border...
    local coords = agc.circ(x, y, r)

    x = math.floor(x)
    y = math.floor(y)
    r = math.floor(r)

    -- ...then add coords of fill.
    for ty=-r,r do
        for tx=-r,r do
            if(tx*tx+ty*ty <= r*r) then
                table.insert(coords, {
                    x = (x + tx) * g.screen.gamepixel.w,
                    y = (y + ty) * g.screen.gamepixel.h
                })
            end
        end
    end

    return coords
end


function agc.oval(x, y, rx, ry)
    --[[
    Function Oval calculates coordinates of every point that make
    an empty (ie not filled) ellipse.
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

    Returns
    -------
    nothing
    ]]--

    local coords = {}

    x = math.floor(x)
    y = math.floor(y)
    rx = math.floor(rx)
    ry = math.floor(ry)

    local dx, dy, d1, d2
    local xx = 0;
    local yy = ry;
    d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
    dx = 2 * ry * ry * xx
    dy = 2 * rx * rx * yy

    while (dx < dy) do
        table.insert(coords, {
            x = (xx + x) * g.screen.gamepixel.w,
            y = (yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (-xx + x) * g.screen.gamepixel.w,
            y = (yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (xx + x) * g.screen.gamepixel.w,
            y = (-yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (-xx + x) * g.screen.gamepixel.w,
            y = (-yy + y) * g.screen.gamepixel.h
        })
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
        table.insert(coords, {
            x = (xx + x) * g.screen.gamepixel.w,
            y = (yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (-xx + x) * g.screen.gamepixel.w,
            y = (yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (xx + x) * g.screen.gamepixel.w,
            y = (-yy + y) * g.screen.gamepixel.h
        })
        table.insert(coords, {
            x = (-xx + x) * g.screen.gamepixel.w,
            y = (-yy + y) * g.screen.gamepixel.h
        })
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

    return coords
end


function agc.ovalfill(x, y, rx, ry)
    --[[
    Function Oval calculates coordinates of every point that make
    an filled ellipse.
    It uses midpoint ellipse algorithm – it draws lines between the border points.

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

    Returns
    -------
    nothing
    ]]--
    local coords = {}

    x = math.floor(x)
    y = math.floor(y)
    rx = math.floor(rx)
    ry = math.floor(ry)

    local dx, dy, d1, d2
    local xx = 0;
    local yy = ry;
    d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
    dx = 2 * ry * ry * xx
    dy = 2 * rx * rx * yy

    while (dx < dy) do
        local line_1 = agc.line(x - xx, y + yy, x + xx, y + yy)
        local line_2 = agc.line(x - xx, y - yy, x + xx, y - yy)
        for i=1, #line_1 do
            coords[#coords+1] = line_1[i]
        end
        for i=1, #line_2 do
            coords[#coords+1] = line_2[i]
        end
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
        local line_1 = agc.line(x - xx, y + yy, x + xx, y + yy)
        local line_2 = agc.line(x - xx, y - yy, x + xx, y - yy)
        for i=1, #line_1 do
            coords[#coords+1] = line_1[i]
        end
        for i=1, #line_2 do
            coords[#coords+1] = line_2[i]
        end
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

    return coords
end


return agc
