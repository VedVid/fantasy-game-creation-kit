require "api"

local actions = require "game/actions"
local enemies = require "game/enemies"
local map = require "game/map"
local player = require "game/player"


function Init()
    map.current_map = {
        map.neutral_tile_old,
        map.neutral_tile,
        map.enemy_tile,
        map.item_tile,
        map.enemy_tile,
        map.item_tile,
        map.enemy_tile
    }
    enemies.current_enemy = enemies.spider
    player.current_tile = map.current_map[2]
end


function Input()
    if Btnp("left") then
        if actions.currently_selected > 1 then
            actions.currently_selected = actions.currently_selected - 1
        end
    elseif Btnp("right") then
        local max_actions = 0
        if player.current_tile == map.enemy_tile then
            max_actions = #actions.all_actions.enemy
        else
            -- neutral tiles, _old tiles
            max_actions = #actions.all_actions.free
        end
        if actions.currently_selected < max_actions then
                actions.currently_selected = actions.currently_selected + 1
        end
    elseif Btnp("z") then
        local pool_of_actions = nil
        if player.current_tile == map.enemy_tile then
            pool_of_actions = actions.all_actions.enemy
        else
            pool_of_actions = actions.all_actions.free
        end
        if pool_of_actions[actions.currently_selected].amount > 0 then
            pool_of_actions[actions.currently_selected].amount =
            pool_of_actions[actions.currently_selected].amount - 1
            if pool_of_actions[actions.currently_selected] == actions.attack then
                enemies.current_enemy.current_hp = enemies.current_enemy.current_hp - 1
                if actions.attack.cooldown_current <= 0 then
                    actions.attack.cooldown_current = actions.attack.cooldown_max
                end
            elseif pool_of_actions[actions.currently_selected].element == enemies.current_enemy.element then
                enemies.current_enemy.current_hp = 0
            else
                enemies.current_enemy.current_hp = enemies.current_enemy.current_hp - 2
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
    actions.draw_frame(player.current_tile)
    actions.draw_buttons(player.current_tile)
    enemies.draw_current_enemy(player.current_tile)
end
