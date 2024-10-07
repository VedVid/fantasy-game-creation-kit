local luaunit = require "luaunit"

local g = require "globals"
local editor = require "sprite_editor"
local sprite = require "sprite"


--[[ Start of TestSetCurrentTab ]]

TestSetCurrentTab = {}


function TestSetCurrentTab:setUp()
    g.sprites.path = g.sprites.path_test
    g.sprites.sprites = sprite.get_all_sprites()
end


function TestSetCurrentTab:test__should_set_correct_tab__when_called_with_minimal_value()
    local num = 1

    editor.set_current_tab(num)

    luaunit.assertEquals(editor.current_tab, 1)
end


function TestSetCurrentTab:test__should_set_correct_tab__when_called_with_maximal_value()
    local num = 3

    editor.set_current_tab(num)

    luaunit.assertEquals(editor.current_tab, 3)
end


--[[ End of TestSetCurrentTab ]]


--[[ Start of TestSetCurrentSprite ]]

TestSetCurrentSprite = {}


function TestSetCurrentSprite:setUp()
    g.sprites.path = g.sprites.path_test
    g.sprites.sprites = sprite.get_all_sprites()
end


function TestSetCurrentSprite:test__should_ensure_that_current_sprite_is_not_nil__when_setting_current_sprite()
    local num = 2

    editor.set_current_sprite(num)

    luaunit.assertNotNil(editor.current_sprite_data)
end


function TestSetCurrentSprite:test__should_set_correct_sprite__when_called_with_minimal_value()
    local num = 1

    editor.set_current_sprite(num)

    luaunit.assertEquals(editor.current_sprite, 1)
end


function TestSetCurrentSprite:test__should_set_correct_sprite__when_called_with_maximal_argument()
    local num = g.sprites.amount

    editor.set_current_sprite(num)

    luaunit.assertEquals(editor.current_sprite, g.sprites.amount)
end


--[[ End of TestSetCurrentSprite ]]


--[[ Start of TestSetCurrentColor ]]

TestSetCurrentColor = {}


function TestSetCurrentColor:setUp()
    -- Just to be sure, if I change something in the set_current_color implementation
    -- and I forget to update the tests...
    g.sprites.path = g.sprites.path_test
end


function TestSetCurrentColor:test__should_set_correct_color__when_called_with_minimal_value()
    local num = 1

    editor.set_current_color(num)

    luaunit.assertEquals(editor.current_color, 1)
end


function TestSetCurrentColor:test__should_set_correct_color__when_called_with_maximal_value()
    local num = #editor.colors

    editor.set_current_color(num)

    luaunit.assertEquals(editor.current_color, #editor.colors)
end


--[[ End of TestSetCurrentColor ]]


--[[ Start of TestSetCurrentMode ]]

TestSetCurrentMode = {}


function TestSetCurrentMode:test__should_set_correct_mode__when_string_mode_is_passed_as_argument()
    for k, v in pairs(editor.modes) do
        editor.set_current_mode(v)
        luaunit.assertEquals(editor.current_mode, v)
    end
end


--[[ End of TestSetCurrentMode ]]


--[[ Start of TestSwitchCurrentToggleMode ]]

TestSwitchCurrentToggleMode = {}


function TestSwitchCurrentToggleMode:test__should_ensure_hold_as_current_toggle__when_drawing_mode_is_set_to_point_mode_and_current_toggle_starts_in_press_mode()
    editor.current_toggle = editor.toggle.press
    editor.current_mode = editor.modes.point

    editor.switch_current_toggle_mode()

    luaunit.assertEquals(editor.current_toggle, editor.toggle.hold)
end


function TestSwitchCurrentToggleMode:test__should_ensure_hold_as_current_toggle__when_drawing_mode_is_set_to_point_mode_and_current_toggle_starts_in_hold_mode()
    editor.current_toggle = editor.toggle.hold
    editor.current_mode = editor.modes.point

    editor.switch_current_toggle_mode()

    luaunit.assertEquals(editor.current_toggle, editor.toggle.hold)
end


function TestSwitchCurrentToggleMode:test__should_ensure_press_as_current_toggle__when_drawing_mode_is_not_set_to_point_mode_and_current_toggle_starts_in_press_mode()
    for k, v in pairs(editor.modes) do
        if v ~= editor.modes.point then
            editor.current_toggle = editor.toggle.press
            editor.current_mode = v

            editor.switch_current_toggle_mode()

            luaunit.assertEquals(editor.current_toggle, editor.toggle.press)
        end
    end
end


function TestSwitchCurrentToggleMode:test__should_ensure_press_as_current_toggle__when_drawing_mode_is_not_set_to_point_mode_and_current_toggle_starts_in_hold_mode()
    for k, v in pairs(editor.modes) do
        if v ~= editor.modes.point then
            editor.current_toggle = editor.toggle.hold
            editor.current_mode = v

            editor.switch_current_toggle_mode()

            luaunit.assertEquals(editor.current_toggle, editor.toggle.press)
        end
    end
end


--[[ End of TestSwitchCurrentToggleMode ]]


os.exit(luaunit.LuaUnit.run())
