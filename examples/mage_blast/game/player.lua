require "../api"


local player = {}


player.current_hp = 5
player.points = 0

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
    Rectfill(0, 0, 256/2, 8, Red)
    Rectfill((256 / 2), 0, 256 / 2, 8, Yellow)
    Write(20, 1, "HP: " .. tostring(player.current_hp), RedBold)
    Write((256 / 2) + 20, 1, "Points: " .. tostring(player.points), YellowBold)
end


function player.print_score()
    local start_string_y = 192 / 2 - 30
    local points_string = tostring(player.points)
    Write((256 / 2) - 16, start_string_y, "GAME OVER", Yellow)
    Write((256 / 2) - 13, start_string_y + 20, "You scored")
    Write((256 / 2) - (4 * (math.floor(#points_string / 2))) + 3, start_string_y + 30, points_string, GreenBold)
    Write((256 / 2) - 5, start_string_y + 40, "points")
end


return player
