local map = require "game/map"


local actions = {}


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

actions.wand = {}
actions.wand.sprite_empty = {
    {37, 38, 39},
    {67, 68, 69},
    {97, 98, 99}
}
actions.wand.sprite_available = {
    {40, 41, 42},
    {70, 71, 72},
    {100, 101, 102}
}
actions.wand.amount = 1

actions.potion = {}
actions.potion.sprite_empty = {
    {43, 44, 45},
    {73, 74, 75},
    {103, 104, 105}
}
actions.potion.sprite_available = {
    {46, 47, 48},
    {76, 77, 78},
    {106, 107, 108}
}
actions.potion.amount = 1

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

actions.air = {}
actions.air.sprite_empty = {
    {130, 131, 132},
    {160, 161, 162},
    {133, 134, 135}
}
actions.air.sprite_available = {
    {136, 137, 138},
    {166, 167, 168},
    {163, 164, 165}
}
actions.air.amount = 1

actions.all_actions = {
    enemy = {
        actions.attack,
        actions.fire,
        actions.earth,
        actions.water,
        actions.air
    },
    item = {
        "Pick up",
        "Ignore"
    },
    free = {
        actions.potion,
        actions.wand
    }
}

actions.currently_selected = 1


local icons_start_x = 52
local icons_start_y = 100
local icons_distance_between_x = 32


function actions.draw_buttons(current_tile)
    local current_x = icons_start_x
    local current_y = icons_start_y

    local actions_to_be_drawn = actions.all_actions.free

    if current_tile == map.enemy_tile then
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


function actions.draw_frame(current_tile)
    if current_tile ~= map.enemy_tile and current_tile ~= map.neutral_tile then return end
    Spr(icons_start_x - 4 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4, 139)
    Spr(icons_start_x - 4 + 24 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4, 140)
    Spr(icons_start_x - 4 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4 + 24, 169)
    Spr(icons_start_x - 4 + 24 + (icons_distance_between_x * (actions.currently_selected - 1)), icons_start_y + 4 + 24, 170)
end


return actions
