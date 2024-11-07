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
    if Btnp("left") then
        if actions.currently_selected > 1 then
            actions.currently_selected = actions.currently_selected - 1
        end
    elseif Btnp("right") then
        if actions.currently_selected < #actions.all_actions.enemy then
            actions.currently_selected = actions.currently_selected + 1
        end
    elseif Btnp("z") then
        if actions.all_actions.enemy[actions.currently_selected].amount > 0 then
            actions.all_actions.enemy[actions.currently_selected].amount =
            actions.all_actions.enemy[actions.currently_selected].amount - 1
        end
    end
end


function Update()
    do end
end


function Draw()
    map.draw_map()
    actions.draw_frame()
    actions.draw_buttons()
end
