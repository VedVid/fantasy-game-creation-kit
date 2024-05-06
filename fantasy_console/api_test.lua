local luaunit = require "luaunit"

require "api"


--[[ Start of TestJoin ]]

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


--[[ End of TestJoin ]]


--[[ Start of TestSplit ]]

TestSplit = {}


function TestSplit:test__should_return_two_strings__when_hello_world_passed_as_argument()
    local s = "Hello World"

    local result = Split(s)
    local hello = "Hello"
    local world = "World"

    luaunit.assertEquals(result[1], hello)
    luaunit.assertEquals(result[2], world)
end


function TestSplit:test__should_return_original_string__when_delimiter_set_to_empty_string()
    local s = "Hello World"

    local result = Split(s, "")
    local helloworld = "Hello World"

    luaunit.assertEquals(result[1], helloworld)
end


function TestSplit:test__should_split_correctly__when_using_custom_delimiter()
    local s = "Hello;World"

    local result = Split(s, ";")
    local hello = "Hello"
    local world = "World"

    luaunit.assertEquals(result[1], hello)
    luaunit.assertEquals(result[2], world)
end


function TestSplit:test__should_split_correctly__when_using_multichar_delimiter()
    local s = "Hello7^#World"

    local result = Split(s, "7^#")
    local hello = "Hello"
    local world = "World"

    luaunit.assertEquals(result[1], hello)
    luaunit.assertEquals(result[2], world)
end


function TestSplit:test__should_return_original_string__when_using_delimiter_not_present_in_string()
    local s = "Hello World"

    local result = Split(s, "-")
    local helloworld = "Hello World"

    luaunit.assertEquals(result[1], helloworld)
end

--[[ End of TestSplit ]]


os.exit( luaunit.LuaUnit.run() )
