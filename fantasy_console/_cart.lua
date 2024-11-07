require "api"

local actions = require "game/actions"
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
    actions.draw_frame()
    actions.draw_buttons()
end
