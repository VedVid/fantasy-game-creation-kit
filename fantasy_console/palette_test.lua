local luaunit = require "luaunit"

local palette = require "palette"


--[[ Start of TestPalette ]]

TestPalette = {}


function TestPalette:test__should_error__when_called_with_hexcode_in_incorrect_format()
    local invalid_hexcode = "FFFFFF"

    luaunit.assertErrorMsgContains(
        "Couldn't find correct color for hex value: " .. invalid_hexcode,
        palette.find_color_by_hex,
        invalid_hexcode
    )
end


function TestPalette:test__should_error__when_called_with_hexcode_not_supported_by_engine()
    local unsupported_hexcode = "#FFFFFF"

    luaunit.assertErrorMsgContains(
        "Couldn't find correct color for hex value: " .. unsupported_hexcode,
        palette.find_color_by_hex,
        unsupported_hexcode
    )
end


function TestPalette:test__should_return_correct_palette_color__when_called_with_correct_hexcode()
    local correct_hexcode = palette.white_bold.hex

    local value_returned = palette.find_color_by_hex(correct_hexcode)

    luaunit.assertEquals(value_returned, palette.white_bold)
end


--[[ End of TestPalette ]]


os.exit(luaunit.LuaUnit.run())
