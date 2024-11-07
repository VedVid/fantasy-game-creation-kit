local actions = {}


actions.attack = {}
actions.attack.sprite_basic = {
    {31, 32, 33},
    {61, 62, 63},
    {91, 92, 93}
}
actions.attack.sprite_active = {
    {34, 35, 36},
    {64, 65, 66},
    {94, 95, 96}
}

actions.wand = {}
actions.wand.sprite_basic = {
    {37, 38, 39},
    {67, 68, 69},
    {97, 98, 99}
}
actions.wand.sprite_active = {
    {40, 41, 42},
    {70, 71, 72},
    {100, 101, 102}
}

actions.potion = {}
actions.potion.sprite_basic = {
    {43, 44, 45},
    {73, 74, 75},
    {103, 104, 105}
}
actions.potion.sprite_active = {
    {46, 47, 48},
    {76, 77, 78},
    {106, 107, 108}
}

actions.fire = {}
actions.fire.sprite_basic = {
    {52, 53, 54},
    {82, 83, 84},
    {112, 113, 114}
}
actions.fire.sprite_active = {
    {49, 50, 51},
    {79, 80, 81},
    {109, 110, 111}
}

actions.water = {}
actions.water.sprite_basic = {
    {58, 59, 60},
    {88, 89, 90},
    {118, 119, 120}
}
actions.water.sprite_active = {
    {55, 56, 57},
    {85, 86, 87},
    {115, 116, 117}
}

actions.earth = {}
actions.earth.sprite_basic = {
    {121, 122, 123},
    {151, 152, 153},
    {124, 125, 126}
}
actions.earth.sprite_active = {
    {127, 128, 129},
    {157, 158, 159},
    {154, 155, 156}
}

actions.air = {}
actions.air.sprite_basic = {
    {130, 131, 132},
    {160, 161, 162},
    {133, 134, 135}
}
actions.air.sprite_active = {
    {136, 137, 138},
    {166, 167, 168},
    {163, 164, 165}
}

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
        actions.potion
    }
}


local icons_start_x = 52
local icons_start_y = 100 + (8 * 4)
local icons_distance_between_x = 32


function actions.draw_buttons()
    local current_x = icons_start_x
    local current_y = icons_start_y
    -- if next tile is enemy:
        -- always draw attack, with no info below it
        -- always draw wand, with info about amount of consumables available
        -- always draw potion, with info about amount of consumables available
    for _, action in ipairs(actions.all_actions.enemy) do
        for i, row in ipairs(action.sprite_basic) do
            Spr(current_x, current_y + (8 * i), row[1])
            Spr(current_x + 8, current_y + (8 * i), row[2])
            Spr(current_x + 16, current_y + (8 * i), row[3])
        end
        current_x = current_x + icons_distance_between_x
    end
end


return actions
