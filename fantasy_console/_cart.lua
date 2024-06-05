require "api"

local score = 0
local x_dir = 0
local y_dir = 0
local snake_x = 0
local snake_y = 0
local fruit_x = 0
local fruit_y = 0
local map_x_min = 0
local map_x_max = 256
local map_y_min = 8
local map_y_max = 192
local game_over = false

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
    if game_over == true then
        return
    end
    Update_snake()
end

function Draw()
    Cls()
    Draw_score_bg()
    Draw_score()
    Draw_fruit()
    Draw_snake()
    if game_over == true then
        Write("GAME OVER", 100, 1)
    end
end


function Draw_score()
    Write("Score: " .. score, 1, 1, White)
end


function Draw_score_bg()
    Rectfill(0, 0, 256, 8, Cyan)
end


function Draw_fruit()
    Rectfill(fruit_x, fruit_y, 8, 8, Pink)
end


function Draw_snake()
    Rectfill(snake_x, snake_y, 8, 8, Green)
end


function Update_snake()
    snake_x = snake_x + (x_dir * 8)
    snake_y = snake_y + (y_dir * 8)
    if snake_x <= map_x_min or snake_x >= map_x_max - 8 then
        game_over = true
    end
    if snake_y <= map_y_min or snake_y >= map_y_max - 8 then
        game_over = true
    end
end
