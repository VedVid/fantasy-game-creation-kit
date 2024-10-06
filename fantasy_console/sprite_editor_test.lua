local luaunit = require "luaunit"

local g = require "globals"
local editor = require "sprite_editor"


--[[ Start of TestSpriteEditor ]]

TestSpriteEditor = {}


function TestSpriteEditor:test__foo()
    local foo = nil
    luaunit.assertNil(foo)
end


--[[ End of TestSpriteEditor ]]


os.exit(luaunit.LuaUnit.run())
