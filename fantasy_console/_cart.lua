require "api"

local score = 0
local x_dir = 0
local y_dir = 0
local snake_x = 0
local snake_y = 0
local fruit_x = 0
local fruit_y = 0

function Init()
    x_dir = 1
    fruit_x = 3 * 8
    fruit_y = 3 * 8
    snake_x = 8 * 8
    snake_y = 8 * 8
end

function Input()
    if Btn("left") then
        x_dir = -1
        y_dir = 0
    elseif Btn("right") then
        x_dir = 1
        y_dir = 0
    elseif Btn("up") then
        x_dir = 0
        y_dir = -1
    elseif Btn("down") then
        x_dir = 0
        y_dir = 1
    end
end

function Update()
    do end
end

function Draw()
    Cls()
    Draw_score()
    Draw_fruit()
    Draw_snake()
end


function Draw_score()
    Write("Score: " .. score, 1, 1, White)
end


function Draw_fruit()
    Rectfill(fruit_x, fruit_y, 8, 8, Pink)
end


function Draw_snake()
    Rectfill(snake_x, snake_y, 8, 8, Green)
end
