local luaunit = require "luaunit"

local g = require "globals"
local sprite = require "sprite"


--[[ Start of TestGetSprite ]]

TestGetSprite = {}


function TestGetSprite:setUp()
    g.sprites.path = g.sprites.path_test
end


function TestGetSprite:test__should_error__when_sprite_number_is_negative()
    local negative_sprite_number = -1

    luaunit.assertErrorMsgContains(
        "is smaller than 1",
        sprite.get_sprite,
        negative_sprite_number
    )
end


function TestGetSprite:test__should_error__when_sprite_number_equals_to_zero()
    local zero_sprite_number = 0

    luaunit.assertErrorMsgContains(
        "is smaller than 1",
        sprite.get_sprite,
        zero_sprite_number
    )
end


function TestGetSprite:test__should_error__when_sprite_number_is_larger_than_total_amount_of_sprites_supported()
    local large_sprite_number = g.sprites.amount + 1

    luaunit.assertErrorMsgContains(
        "is larger than",
        sprite.get_sprite,
        large_sprite_number
    )
end


function TestGetSprite:test__should_return_sprite__when_sprite_number_equals_to_1()
    g.sprites.sprites = sprite.get_all_sprites()
    local valid_sprite_number = 1

    local sprite_found = sprite.get_sprite(valid_sprite_number)

    luaunit.assertNotNil(sprite_found)
end


function TestGetSprite:test__should_return_sprite__when_sprite_number_equals_to_last_sprite()
    g.sprites.sprites = sprite.get_all_sprites()
    local large_sprite_number = g.sprites.amount

    local sprite_found = sprite.get_sprite(large_sprite_number)

    luaunit.assertNotNil(sprite_found)
end


--[[ End of TestGetSprite ]]


--[[ Start of TestGetAllSprites ]]

TestGetAllSprites = {}

function TestGetAllSprites:test__should_error__when_there_is_no_sprites_file()
    g.sprites.path = "some/incorrect/path/to/sprites.json"

    luaunit.assertErrorMsgContains(
        "No such file or directory",
        sprite.get_all_sprites
    )
end


function TestGetAllSprites:test__should_return_sprite_table__when_file_is_present()
    g.sprites.path = g.sprites.path_test

    local sprites_table = sprite.get_all_sprites()

    luaunit.assertNotNil(sprites_table)
end


--[[ End of TestGetAllSprites ]]


--[[ Start of TestNewBlankSprite ]]

TestNewBlankSprite = {}

function TestNewBlankSprite:test__should_return_sprite__when_called()
    local new_sprite = sprite.new_blank_sprite()

    luaunit.assertNotNil(new_sprite)
end


function TestNewBlankSprite:test__should_return_sprite_consisting_of_only_default_color_pixels()
    local new_sprite = sprite.new_blank_sprite()

    local colors = sprite.return_sprite_colors(new_sprite)

    for _, hexcode in ipairs(colors) do
        luaunit.assertEquals(hexcode, sprite.default_color.hex)
    end
end


--[[ End of TestNewBlankSprite ]]


--[[ Start of TestInitializeBlankSprites ]]

TestInitializeBlankSprites = {}

function TestInitializeBlankSprites:test__should_initialize_blank_sprites_correctly__when_there_is_no_sprites_file_present()
    g.sprites.path = g.sprites.path_test
    os.remove(g.sprites.path_test)
    local f = io.open(g.sprites.path, "r")
    if f ~= nil then
        io.close(f)
        error('Test file sprites_test.json is not removed! Tests aborted.')
    end

    sprite.initialize_blank_sprites()

    local f = io.open(g.sprites.path, "r")
    if f == nil then
        error('Test file sprites_test.json has not been created! Tests aborted.')
    end
    io.close(f)
end


--[[ Stop of TestInitializeBlankSprites ]]


os.exit(luaunit.LuaUnit.run())
