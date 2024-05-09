local luaunit = require "luaunit"

local g = require "globals"
local gamepixel = require "gamepixel"
local palette = require "palette"


--[[ Start of TestGamepixel ]]

TestGamepixel = {}


function TestGamepixel:test__should_create_gamepixel_with_default_values__when_arguments_are_set_to_nil()
    local pixel = gamepixel.new_gamepixel()

    luaunit.assertEquals(pixel.x, g.screen.gamepixel.w)
    luaunit.assertEquals(pixel.y, g.screen.gamepixel.h)
    luaunit.assertEquals(pixel.color, gamepixel.default_color)
end


function TestGamepixel:test__should_create_gamepixel_with_custom_values__when_arguments_are_provided()
    local pixel = gamepixel.new_gamepixel(12, 28, palette.blue_bold)

    luaunit.assertEquals(pixel.x, 12*g.screen.gamepixel.h)
    luaunit.assertEquals(pixel.y, 28*g.screen.gamepixel.h)
    luaunit.assertEquals(pixel.color, palette.blue_bold)
end

--[[ End of TestGamepixel ]]


os.exit(luaunit.LuaUnit.run())
