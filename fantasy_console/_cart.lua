require "api"

local actions = require "game/actions"
local enemies = require "game/enemies"
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
    enemies.current_enemy = enemies.bat
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
            if actions.all_actions.enemy[actions.currently_selected] == actions.attack then
                actions.attack.cooldown_current = actions.attack.cooldown_max
            end
        end
    end
end


function Update()
    if actions.attack.amount == 0 then
        actions.attack.cooldown_current = actions.attack.cooldown_current - 1
        if actions.attack.cooldown_current == 0 then
            actions.attack.amount = 1
        end
    end
end


function Draw()
    map.draw_map()
    actions.draw_frame()
    actions.draw_buttons()
    enemies.draw_current_enemy()
end
