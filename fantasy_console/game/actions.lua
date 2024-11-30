require "../api"

local enemies = require "game/enemies"


local actions = {}


actions.arrow = {}
actions.arrow.sprite_available = {
    {512, 4, 512},
    {1, 2, 3},
    {512, 5, 512}
}
actions.arrow.amount = 9999

actions.attack = {}
actions.attack.sprite_empty = {
    {31, 32, 33},
    {61, 62, 63},
    {91, 92, 93}
}
actions.attack.sprite_available = {
    {34, 35, 36},
    {64, 65, 66},
    {94, 95, 96}
}
actions.attack.amount = 1
actions.attack.cooldown_max = 60
actions.attack.cooldown_current = 0
actions.attack.element = 0

actions.fire = {}
actions.fire.sprite_empty = {
    {52, 53, 54},
    {82, 83, 84},
    {112, 113, 114}
}
actions.fire.sprite_available = {
    {49, 50, 51},
    {79, 80, 81},
    {109, 110, 111}
}
actions.fire.amount = 1
actions.fire.element = 8

actions.water = {}
actions.water.sprite_empty = {
    {58, 59, 60},
    {88, 89, 90},
    {118, 119, 120}
}
actions.water.sprite_available = {
    {55, 56, 57},
    {85, 86, 87},
    {115, 116, 117}
}
actions.water.amount = 1
actions.water.element = 6

actions.earth = {}
actions.earth.sprite_empty = {
    {121, 122, 123},
    {151, 152, 153},
    {124, 125, 126}
}
actions.earth.sprite_available = {
    {127, 128, 129},
    {157, 158, 159},
    {154, 155, 156}
}
actions.earth.amount = 1
actions.earth.element = 9

actions.air = {}
actions.air.sprite_empty = {
    {46, 47, 48},
    {76, 77, 78},
    {106, 107, 108}
}
actions.air.sprite_available = {
    {43, 44, 45},
    {73, 74, 75},
    {103, 104, 105}
}
actions.air.amount = 1
actions.air.element = 7


actions.all_actions = {
    enemy = {
        actions.attack,
        actions.fire,
        actions.earth,
        actions.water,
        actions.air
    },
    free = {
        actions.arrow
    }
}

actions.currently_selected = 1


local icons_start_x = 52
local icons_start_y = 100
local icons_distance_between_x = 32


function actions.draw_buttons()
    local current_x = icons_start_x
    local current_y = icons_start_y

    local actions_to_be_drawn = actions.all_actions.free

    if enemies.current_enemy.current_hp > 0 then
        actions_to_be_drawn = actions.all_actions.enemy
    end

    for _, action in ipairs(actions_to_be_drawn) do
        local sprite_to_be_drawn = action.sprite_empty
        if action.amount > 0 then
            sprite_to_be_drawn = action.sprite_available
        end
        for i, row in ipairs(sprite_to_be_drawn) do
            Spr(current_x, current_y + (8 * i), row[1])
            Spr(current_x + 8, current_y + (8 * i), row[2])
            Spr(current_x + 16, current_y + (8 * i), row[3])
        end
        current_x = current_x + icons_distance_between_x
    end
end


function actions.draw_frame()
    Spr(icons_start_x - 4 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4, 130)
    Spr(icons_start_x - 4 + 24 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4, 131)
    Spr(icons_start_x - 4 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4 + 24, 160)
    Spr(icons_start_x - 4 + 24 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4 + 24, 161)
end


return actions
