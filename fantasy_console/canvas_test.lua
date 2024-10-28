local luaunit = require "luaunit"

local canvas = require "canvas"
local g = require "globals"


--[[ Start of Test__set_global_screen_variables ]]

Test__set_global_screen_variables = {}


function Test__set_global_screen_variables:test__should_return_error__when_scale_font_and_gamepixels_are_nils()
    luaunit.assertErrorMsgContains(
        "Error in canvas.set_global_screen_variables",
        canvas.set_global_screen_variables,
        nil,
        nil,
        nil,
        nil
    )
end


function Test__set_global_screen_variables:test__should_use_scale__when_both_scale_and_gamepixels_with_font_size_are_provided()
    local scale = canvas.scale_3840x2160
    local gamepixel_w = 2
    local gamepixel_h = 2
    local font_size = 2

    canvas.set_global_screen_variables(scale, gamepixel_w, gamepixel_h, font_size)

    luaunit.assertEquals(
        g.screen.size.pixels.w,
        g.screen.size.gamepixels.w * canvas.scale_3840x2160.gamepixel_w
    )

    luaunit.assertEquals(
        g.screen.size.pixels.h,
        g.screen.size.gamepixels.h * canvas.scale_3840x2160.gamepixel_h
    )

    luaunit.assertEquals(
        g.screen.font_size,
        canvas.scale_3840x2160.font_size
    )
end


--[[ End of Test__set_global_screen_variables ]]


os.exit(luaunit.LuaUnit.run())
