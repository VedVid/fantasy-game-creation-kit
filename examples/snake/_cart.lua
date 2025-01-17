require "api"


local score = 0
local x_dir = 0
local y_dir = 0
local snake_x = {}
local snake_y = {}
local fruit_x = 0
local fruit_y = 0
local map_x_min = 0
local map_x_max = 256
local map_y_min = 8
local map_y_max = 192
local started = false
local game_over = false


function Init()
    x_dir = 1
    Update_fruit()
    snake_x[1] = 8 * 8
    snake_y[1] = 8 * 8
end


function Input()
    if started == false then
        if Btn("space") then
            started = true
        end
    end
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
    if game_over == true or started == false then
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
    if started == false then
        Write(80, 1, "Press [space] to start")
    end
    if game_over == true then
        Write(100, 1, "GAME OVER")
    end
end


function Draw_score()
    Write(1, 1, "Score: " .. score, White)
end


function Draw_score_bg()
    Rectfill(0, 0, 256, 8, Cyan)
end


function Draw_fruit()
    Rectfill(fruit_x, fruit_y, 8, 8, Pink)
end


function Draw_snake()
    Rectfill(snake_x[1], snake_y[1], 8, 8, Green)
    for i = 2, #snake_x do
        Rectfill(snake_x[i], snake_y[i], 8, 8, GreenBold)
    end
end


function Update_snake()
    local tmp_x_1 = snake_x[1]
    local tmp_y_1 = snake_y[1]
    local tmp_x_2, tmp_y_2

    snake_x[1] = snake_x[1] + (x_dir * 8)
    snake_y[1] = snake_y[1] + (y_dir * 8)

    for i = 2, #snake_x do
        tmp_x_2 = snake_x[i]
        tmp_y_2 = snake_y[i]
        snake_x[i] = tmp_x_1
        snake_y[i] = tmp_y_1
        tmp_x_1 = tmp_x_2
        tmp_y_1 = tmp_y_2
    end

    if snake_x[1] <= map_x_min or snake_x[1] >= map_x_max - 8 then
        game_over = true
        return
    end

    if snake_y[1] <= map_y_min or snake_y[1] >= map_y_max - 8 then
        game_over = true
        return
    end

    if snake_x[1] == fruit_x and snake_y[1] == fruit_y then
        score = score + 10
        for i = #snake_x + 1, 2, -1 do
            snake_x[i] = snake_x[i-1]
            snake_y[i] = snake_y[i-1]
        end
        snake_x[1] = fruit_x
        snake_y[1] = fruit_y
        Update_fruit()
    end
end


function Update_fruit()
    while true do
        fruit_x = math.random(0, 256)
        fruit_y = math.random(8, 192)
        if (fruit_x ~= snake_x[1] or fruit_y ~= snake_y[1]) and
        (fruit_x % 8 == 0 and fruit_y % 8 == 0) then
            break
        end
    end
end
