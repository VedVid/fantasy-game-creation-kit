local luaunit = require "luaunit"

require "api"


TestJoin = {}


function TestJoin:test__should_return_single_string__when_multiple_strings_passed()
    local strings = {"abcd", "efgh", "ijkl"}

    local result = Join(strings)

    luaunit.assertEquals(result, "abcdefghijkl")
end


function TestJoin:test__should_add_spaces__when_delimiter_is_set_to_space()
    local strings = {"abcd", "efgh", "ijkl"}
    local delimiter = " "

    local result = Join(strings, delimiter)

    luaunit.assertEquals(result, "abcd efgh ijkl")
end


function TestJoin:test__should_add_custom_delimiter__when_custom_delimiter_is_passed()
    local strings = {"abcd", "efgh", "ijkl"}
    local delimiter = "=*="

    local result = Join(strings, delimiter)

    luaunit.assertEquals(result, "abcd=*=efgh=*=ijkl")
end


function TestJoin:test__should_return_initial_string__when_table_with_single_screen_passed()
    local strings = {"abcd"}

    local result = Join(strings, ";")

    luaunit.assertEquals(result, "abcd")
end


--[[ End of the TestJoin ]]

os.exit( luaunit.LuaUnit.run() )
