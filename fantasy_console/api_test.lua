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


--[[ Start of TestSub  ]]

-- Unfortunately, due the number of reasons related to
-- UTF-8 implementation (see api.Sub block comment for details),
-- Sub function can not be easily tested within this environment.
-- Still, I performed a couple of manual tests that I want to
-- document here.
-- - Test 1
--   - git commit: 042a8d65bdfe499ea1ad9dd0f3aca7e4f508b6d0
--   - test case: Sub("Hello from Love2D!", 1, 5)
--   - expected result: "Hello"
--   - returned result: "Hello"
--   - OK
-- - Test 2
--   - git commit: bf7557296240a133bb5a95889865ef8c0eff3119
--   - test case: Sub("Hello from Love2D!", 1, -4)
--   - expected result: "H"
--   - returned result: "H"
--   - OK

--[[ End of TestSub ]]


os.exit( luaunit.LuaUnit.run() )
