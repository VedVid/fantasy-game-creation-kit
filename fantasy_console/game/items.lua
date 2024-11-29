local enemies = require "game/enemies"


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


return items
