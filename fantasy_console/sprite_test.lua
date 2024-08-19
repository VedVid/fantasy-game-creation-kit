local luaunit = require "luaunit"

local g = require "globals"
local sprite = require "sprite"


--[[ Start of TestGetSprite ]]

TestGetSprite = {}


function TestGetSprite:test__should_error__when_sprite_number_is_negative()
    local negative_sprite_number = -1

    luaunit.assertErrorMsgContains(
        "is smaller than 1",
        sprite.get_sprite,
        negative_sprite_number
    )
end


function TestGetSprite:test__should_error__when_sprite_number_equals_to_zero()
    g.sprites_path = g.sprites_path_test
    local zero_sprite_number = 0

    luaunit.assertErrorMsgContains(
        "is smaller than 1",
        sprite.get_sprite,
        zero_sprite_number
    )
end


function TestGetSprite:test__should_error__when_sprite_number_is_larger_than_total_amount_of_sprites_supported()
    g.sprites_path = g.sprites_path_test
    local large_sprite_number = g.sprites_amount + 1

    luaunit.assertErrorMsgContains(
        "is larger than",
        sprite.get_sprite,
        large_sprite_number
    )
end 


function TestGetSprite:test__should_return_sprite__when_sprite_number_equals_to_1()
    g.sprites_path = g.sprites_path_test
    local valid_sprite_number = 1

    local sprite_found = sprite.get_sprite(valid_sprite_number)

    luaunit.assertNotNil(sprite_found)
end


function TestGetSprite:test__should_return_sprite__when_sprite_number_equals_to_last_sprite()
    g.sprites_path = g.sprites_path_test
    local large_sprite_number = g.sprites_amount

    local sprite_found = sprite.get_sprite(large_sprite_number)

    luaunit.assertNotNil(sprite_found)
end


--[[ End of TestGetSprite ]]


--[[ Start of TestGetAllSprites ]]

TestGetAllSprites = {}

function TestGetAllSprites:test__should_error__when_there_is_no_sprites_file()
    g.sprites_path = "some/incorrect/path/to/sprites.json"

    luaunit.assertErrorMsgContains(
        "No such file or directory",
        sprite.get_all_sprites
    )
end


function TestGetAllSprites:test__should_return_sprite_table__when_file_is_present()
    g.sprites_path = g.sprites_path_test

    local sprites_table = sprite.get_all_sprites()

    luaunit.assertNotNil(sprites_table)
end


--[[ End of TestGetAllSprites ]]


os.exit(luaunit.LuaUnit.run())
