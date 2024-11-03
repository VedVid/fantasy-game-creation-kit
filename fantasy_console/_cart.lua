require "api"

local map = require "game/map"


function Init()
    map.current_map = {
        map.base_tile,
        map.player_tile,
        map.enemy_tile,
        map.item_tile,
        map.enemy_tile,
        map.item_tile,
        map.enemy_tile
    }
end


function Input()
    do end
end


function Update()
    do end
end


function Draw()
    map.draw_map()
end
