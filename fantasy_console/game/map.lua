require "../api"


local map = {}


map.base_tile = {
    {1, 2, 3},
    {2, 2, 2},
    {4, 2, 5}
}

map.player_tile = {
    {6, 7, 8},
    {7 ,7, 7},
    {9, 7, 10}
}

map.enemy_tile = {
    {11, 12, 13},
    {12, 12, 12},
    {14, 12, 15}
}

map.item_tile = {
    {16, 17, 18},
    {17, 17, 17},
    {19, 17, 20}
}

local map_start_x = 20
local map_start_y = 100
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
