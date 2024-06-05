require "api"

local x = {}
local y = {}
local x_dir = 0
local y_dir = 0
local score = 0
local tile_num = 32
local tile_size = math.floor(192/tile_num)
local fruit = {}
fruit.x = 0
fruit.y = 0
fruit.color=PinkBold

function Init()
    x[1] = math.floor(tile_size * (tile_num / 4))
    y[1] = math.floor(tile_size * (tile_num / 2))
    x_dir = 1
    for i = 2, 7 do
        x[i] = ((x[i-1] / tile_size) - 1) * tile_size
        y[i] = y[1]
    end
    Update_fruit()
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
    if (is_wall_collision()) then
        return
    end
    local collide = false
    collide = is_fruit_collision()
    if collide then
        score = score + 10
        for i=#x+1, 2, -1 do
            x[i] = x[i-1]
            y[i] = y[i-1]
        end
        x[1] = fruit.x
        y[1] = fruit.y
        Update_fruit()
    else
        Update_snake()
    end
end

function Draw()
    Cls()
    Draw_snake()
    Draw_fruit()
    Draw_score()
end


function Draw_fruit()
    Rectfill(
        fruit.x,
        fruit.y,
        fruit.x + tile_size - 1,
        fruit.y + tile_size - 1,
        fruit.color
    )
end


function Draw_score()
    Write("Score: " .. score, 1, 1, White)
end


function Draw_snake()
    Rectfill(
        x[1],
        y[1],
        x[1] + tile_size - 1,
        y[1] + tile_size - 1,
        Green
    )

    for i=2, #x do
        Rectfill(
            x[i],
            y[i],
            x[i] + tile_size - 1,
            y[i] + tile_size - 1,
            GreenBold
        )
    end
end


function Update_fruit()
    fruit.x = math.floor(tile_num * tile_size)
    fruit.y = math.floor(tile_num * tile_size)
end


function Update_snake()
    local temp1x = x[1]
    local temp1y = y[1]
    local temp2x, temp2y
    x[1] = math.floor(x[1] + (x_dir * tile_size))
    y[1] = math.floor(y[1] + (y_dir * tile_size))
    for i=2, #x do
        temp2x = x[i]
        temp2y = y[i]
        x[i] = temp1x
        y[i] = temp1y
        temp1x = temp2x
        temp1y = temp2y
    end
end


function is_fruit_collision()
    if(x[1] + (x_dir * tile_size) == fruit.x and y[1] + (y_dir * tile_size) == fruit.y) then
        return true
    end
    return false
end


function is_wall_collision()
    if(x[1] > 192 or x[1] < 0 or y[1] < 0 or y[1] > 192) then
        return true
    end
    return false
end
