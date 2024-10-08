local g = require "globals"


-- shortcut for `api_geometry_calculations`
local agc = {}


----------------------
---------- GEOMETRY --
----------------------


function agc.pset(x, y)
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
        It has the following form:
            {
                {x: 1, y: 1},
                {x: 2, y: 1},
                ...
            }
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
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)

    local coords = {
        lx = (x * g.screen.gamepixel.w) + (g.screen.gamepixel.w / 2),
        ly = (y * g.screen.gamepixel.h) + (g.screen.gamepixel.h / 2),
        lw = (w - 1) * g.screen.gamepixel.w,
        lh = (h - 1) * g.screen.gamepixel.h
    }

    return coords
end


function agc.rectfill(x, y, w, h)
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)

    local coords = {
        lx = math.floor(x * g.screen.gamepixel.w),
        ly = math.floor(y * g.screen.gamepixel.h),
        lw = math.floor(w * g.screen.gamepixel.w),
        lh = math.floor(h * g.screen.gamepixel.h)
    }

    return coords
end


function agc.circ(x, y, r)
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
