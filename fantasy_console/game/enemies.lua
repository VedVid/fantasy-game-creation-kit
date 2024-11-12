require "../api"


local enemies = {}


enemies.bat = {
    {512, 512, 512, 512},
    {185, 186, 187, 188},
    {215, 216, 217, 218},
    {512, 512, 512, 512}
}

enemies.ghost = {
    {245, 246, 247, 248},
    {275, 276, 277, 278},
    {305, 306, 307, 308},
    {335, 336, 337, 338}
}

enemies.cyclop = {
    {189, 190, 191, 192},
    {219, 220, 221, 222},
    {249, 250, 251, 252},
    {279, 280, 281, 282}
}

enemies.spider = {
    {193, 194, 195, 196},
    {223, 224, 225, 226},
    {253, 254, 255, 256},
    {283, 284, 285, 286}
}


enemies.all_enemies = {
    enemies.bat,
    enemies.ghost,
    enemies.cyclop,
    enemies.spider
}


enemies.current_enemy = nil


local start_x = 80
local start_y = 60


function enemies.draw_current_enemy()
    for i, row in ipairs(enemies.current_enemy) do
        Spr(start_x, start_y + (8 * i), row[1])
        Spr(start_x + 8, start_y + (8 * i), row[2])
        Spr(start_x + 16, start_y + (8 * i), row[3])
        Spr(start_x + 24, start_y + (8 * i), row[4])
    end
end


return enemies
