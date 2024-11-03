require "api"


local base_tile = {
    {1, 2, 3},
    {2, 2, 2},
    {4, 2, 5}
}

local player_tile = {
    {6, 7, 8},
    {7 ,7, 7},
    {9, 7, 10}
}

local enemy_tile = {
    {11, 12, 13},
    {12, 12, 12},
    {14, 12, 15}
}

local item_tile = {
    {16, 17, 18},
    {17, 17, 17},
    {19, 17, 20}
}

local map_start_x = 20
local map_start_y = 100
local map_distance_between_x = 32

local current_map = {}


function Draw_map()
    local current_x = map_start_x
    local current_y = map_start_y

    for _, tile in ipairs(current_map) do
        for i, row in ipairs(tile) do
            Spr(current_x, current_y + (8 * i), row[1])
            Spr(current_x + 8, current_y + (8 * i), row[2])
            Spr(current_x + 16, current_y + (8 * i), row[3])
        end
        current_x = current_x + map_distance_between_x
    end
end


function Init()
    current_map = {
        base_tile, player_tile, enemy_tile, item_tile, enemy_tile, item_tile, enemy_tile
    }
end


function Input()
    do end
end


function Update()
    do end
end


function Draw()
    Draw_map()
end
