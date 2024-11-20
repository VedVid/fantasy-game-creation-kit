require "../api"

local map = require "game/map"


local enemies = {}


enemies.bat = {}
enemies.bat.sprite = {
    {512, 512, 512, 512},
    {185, 186, 187, 188},
    {215, 216, 217, 218},
    {512, 512, 512, 512}
}
enemies.bat.element = 142
enemies.bat.max_hp = 4
enemies.bat.current_hp = 4

enemies.ghost = {}
enemies.ghost.sprite = {
    {245, 246, 247, 248},
    {275, 276, 277, 278},
    {305, 306, 307, 308},
    {335, 336, 337, 338}
}
enemies.ghost.element = 141
enemies.ghost.max_hp = 4
enemies.ghost.current_hp = 4

enemies.cyclop = {}
enemies.cyclop.sprite = {
    {189, 190, 191, 192},
    {219, 220, 221, 222},
    {249, 250, 251, 252},
    {279, 280, 281, 282}
}
enemies.cyclop.element = 144
enemies.cyclop.max_hp = 4
enemies.cyclop.current_hp = 4

enemies.spider = {}
enemies.spider.sprite = {
    {193, 194, 195, 196},
    {223, 224, 225, 226},
    {253, 254, 255, 256},
    {283, 284, 285, 286}
}
enemies.spider.element = 143
enemies.spider.max_hp = 4
enemies.spider.current_hp = 4


enemies.all_enemies = {
    enemies.bat,
    enemies.ghost,
    enemies.cyclop,
    enemies.spider
}


enemies.current_enemy = nil


local start_x = (256 / 2) - 16
local start_y = 45


function enemies.draw_current_enemy(current_tile)
    if current_tile ~= map.enemy_tile then return end
    for i, row in ipairs(enemies.current_enemy.sprite) do
        Spr(start_x, start_y + (8 * i), row[1])
        Spr(start_x + 8, start_y + (8 * i), row[2])
        Spr(start_x + 16, start_y + (8 * i), row[3])
        Spr(start_x + 24, start_y + (8 * i), row[4])
    end
    for i=1,enemies.current_enemy.current_hp do
        Spr(start_x + (8 * i) - 8, start_y + 40, enemies.current_enemy.element)
    end
end


return enemies
