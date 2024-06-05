require "api"

local cx, cy
local rs

local font1 = love.graphics.newFont("Clarity.ttf", 5*8)
local font2 = love.graphics.newFont("Pixuf.ttf", 5*8)
local font4 = love.graphics.newFont("Covenant5x5.ttf", 5*8)
local font5 = love.graphics.newFont("Mini3x5.ttf", 5*8)

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
    love.graphics.setFont(font1)
    Write("Hello, Worldy!", 4, 10)
    love.graphics.setFont(font2)
    Write("Hello, Worldy!", 4, 22)
    love.graphics.setFont(font4)
    Write("Hello, Worldy!", 4, 46)
    love.graphics.setFont(font5)
    Write("Hello, Worldy!", 4, 58)
end
