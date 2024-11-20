require "../api"


local map = {}


map.neutral_tile = {
    {6, 7, 8},
    {7 ,7, 7},
    {9, 7, 10}
}

map.neutral_tile_old = {
    {1, 2, 3},
    {2, 2, 2},
    {4, 2, 5}
}

map.enemy_tile = {
    {11, 12, 13},
    {12, 12, 12},
    {14, 12, 15}
}

map.enemy_tile_old = {
    {21, 22, 23},
    {22, 22, 22},
    {24, 22, 25}
}

map.item_tile = {
    {16, 17, 18},
    {17, 17, 17},
    {19, 17, 20}
}

map.item_tile_old = {
    {26, 27, 28},
    {27, 27, 27},
    {29, 27, 30}
}

local map_start_x = 20
local map_start_y = 132
local map_distance_between_x = 32

map.current_map = {}


function map.draw_map()
    local current_x = map_start_x
    local current_y = map_start_y

    for _, tile in ipairs(map.current_map) do
        for i, row in ipairs(tile) do
            Spr(current_x, current_y + (8 * i), row[1])
            Spr(current_x + 8, current_y + (8 * i), row[2])
            Spr(current_x + 16, current_y + (8 * i), row[3])
        end
        current_x = current_x + map_distance_between_x
    end
end


return map
