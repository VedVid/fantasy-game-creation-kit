require "../api"


local player = {}


player.current_hp = 5

player.sprites = {
    {181, 182, 183, 184},
    {211, 212, 213, 214},
    {241, 242, 243, 244},
    {271, 272, 273, 274}
}


local start_x = (256 / 2) - 48
local start_y = 45

function player.draw_player()
    for i, row in ipairs(player.sprites) do
        Spr(start_x, start_y + (8 * i), row[1])
        Spr(start_x + 8, start_y + (8 * i), row[2])
        Spr(start_x + 16, start_y + (8 * i), row[3])
        Spr(start_x + 24, start_y + (8 * i), row[4])
    end

end


return player
