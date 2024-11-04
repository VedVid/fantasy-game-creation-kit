local actions = {}


actions.all_actions = {
    enemy = {
        "Basic attack",
        "Use magic wand",
        "Drink health potion"
    },
    item = {
        "Pick up",
        "Ignore"
    }
}


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


return actions
