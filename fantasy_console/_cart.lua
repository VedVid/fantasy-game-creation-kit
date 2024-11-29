require "api"

local actions = require "game/actions"
local enemies = require "game/enemies"
local items = require "game/items"
local player = require "game/player"


function Init()
    enemies.current_enemy = enemies.spider
end


function Input()
    if Btnp("left") then
        if actions.currently_selected > 1 then
            actions.currently_selected = actions.currently_selected - 1
        end
    elseif Btnp("right") then
        local max_actions = 0
        if enemies.current_enemy.current_hp > 0 then
            max_actions = #actions.all_actions.enemy
        else
            max_actions = #actions.all_actions.free
        end
        if actions.currently_selected < max_actions then
                actions.currently_selected = actions.currently_selected + 1
        end
    elseif Btnp("z") then
        local pool_of_actions = nil
        if enemies.current_enemy.current_hp > 0 then
            pool_of_actions = actions.all_actions.enemy
        else
            pool_of_actions = actions.all_actions.free
        end
        if pool_of_actions[actions.currently_selected].amount > 0 then
            if pool_of_actions[actions.currently_selected] == actions.arrow then
                enemies.current_enemy = enemies.all_enemies[math.random(#enemies.all_enemies)]
                enemies.current_enemy.current_hp = enemies.current_enemy.max_hp
                items.use_item()
                actions.currently_selected = 1
                return
            end
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
            if pool_of_actions == actions.all_actions.enemy and enemies.current_enemy.current_hp <= 0 then
                actions.currently_selected = 1
                items.current_item = items.all_items[math.random(#items.all_items)]
            end
        end
    end
end


function Update()
    print(player.current_hp)
    if actions.attack.amount == 0 then
        actions.attack.cooldown_current = actions.attack.cooldown_current - 1
        if actions.attack.cooldown_current == 0 then
            actions.attack.amount = 1
        end
    end
end


function Draw()
    actions.draw_frame()
    actions.draw_buttons()
    enemies.draw_current_enemy()
    items.draw_current_item()
end
