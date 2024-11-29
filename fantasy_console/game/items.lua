local actions = require "game/actions"
local enemies = require "game/enemies"
local player = require "game/player"


local items = {}


items.wand = {}
items.wand.sprite = {
    {40, 41, 42},
    {70, 71, 72},
    {100, 101, 102}
}

items.potion = {}
items.potion.sprite = {
    {46, 47, 48},
    {76, 77, 78},
    {106, 107, 108}
}


items.all_items = {
    items.wand,
    items.potion
}


items.current_item = nil


local start_x = (256 / 2) - 16
local start_y = 45


function items.draw_current_item()
    if enemies.current_enemy.current_hp > 0 then return end
    for i, row in ipairs(items.current_item.sprite) do
        Spr(start_x, start_y + (8 * i), row[1])
        Spr(start_x + 8, start_y + (8 * i), row[2])
        Spr(start_x + 16, start_y + (8 * i), row[3])
    end
end


function items.use_item()
    if items.current_item == items.potion then
        player.current_hp = player.current_hp + 1
    elseif items.current_item == items.wand then
        items.use_wand()
    end
end


function items.use_wand()
    local min_charges = 2
    local max_charges = 5
    local boosts_available = actions.all_actions.enemy
    local current_charges = math.random(min_charges, max_charges)
    while current_charges > 0 do
        local stat_to_boost = boosts_available[math.random(#boosts_available)]
        if stat_to_boost ~= actions.all_actions.enemy.attack then
            stat_to_boost.amount = stat_to_boost.amount + 1
            current_charges = current_charges - 1
        end
    end
end


return items
