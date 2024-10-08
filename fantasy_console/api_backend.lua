local g = require "globals"


-- shortcut for `api_backend`
local ab = {}


----------------------
---------- GEOMETRY --
----------------------


function ab.pset(x, y)
    local coords = {
        {
            x = math.floor(x * g.screen.gamepixel.w),
            y = math.floor(y * g.screen.gamepixel.h)
        }
    }

    return coords
end


function ab.line(sx, sy, tx, ty)
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


function ab.rect(x, y, w, h)
    local coords = {
        lx = (x * g.screen.gamepixel.w) + (g.screen.gamepixel.w / 2),
        ly = (y * g.screen.gamepixel.h) + (g.screen.gamepixel.h / 2),
        lw = (w - 1) * g.screen.gamepixel.w,
        lh = (h - 1) * g.screen.gamepixel.h
    }

    return coords
end


function ab.rectfill(x, y, w, h)
    local coords = {
        lx = math.floor(x * g.screen.gamepixel.w),
        ly = math.floor(y * g.screen.gamepixel.h),
        lw = math.floor(w * g.screen.gamepixel.w),
        lh = math.floor(h * g.screen.gamepixel.h)
    }

    return coords
end


function ab.circ(x, y, r)
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


function ab.circfill(x, y, r)
    -- Start by adding coords of circle border...
    local coords = ab.circ(x, y, r)

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


return ab
