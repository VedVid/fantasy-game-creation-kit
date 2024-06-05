require "api"

local cx, cy
local rs

function Init()
    cx, cy = 1, 1
    rs = 4
end

function Input()
    if Btnp("z") then
        rs = rs + 1
    elseif Btnp("x") then
        rs = rs - 1
        if rs <= 1 then rs = 2 end
    elseif Btn("left") then
        cx = cx - 1
        if cx < 1 then cx = 1 end
    elseif Btn("right") then
        cx = cx + 1
    elseif Btn("up") then
        cy = cy - 1
        if cy < 1 then cy = 1 end
    elseif Btn("down") then
        cy = cy + 1
    end
end

function Update()
    do end
end

function Draw()
    Cls()
    Rect(cx, cy, rs, rs, BlueBold)
    Write("Hello, World!", 4, 10)
end
