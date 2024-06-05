local luaunit = require "luaunit"

local utils = require "utils"


--[[ Start of TestStringCheck ]]

TestStringCheck = {}


function TestStringCheck:test__should_return_true__when_string_is_ascii_only()
    local s = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&'()*+,-./0123456789:;<=>?@[\\]^_`{|}~"

    local v = utils.check_if_string_is_valid_ascii(s)

    luaunit.assertEquals(v, true)
end


function TestStringCheck:test__should_return_false__when_there_are_characters_out_of_ascii_standard()
    local s = "abcdệ"

    local v = utils.check_if_string_is_valid_ascii(s)

    luaunit.assertEquals(v, false)
end

--[[ End of TestStringCheck ]]


os.exit(luaunit.LuaUnit.run())
