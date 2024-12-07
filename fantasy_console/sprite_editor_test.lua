local luaunit = require "luaunit"

local g = require "globals"
local editor = require "sprite_editor"
local palette = require "palette"
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


--[[ Start of TestUpdateSaveButton ]]

TestUpdateSaveButton = {}


function TestUpdateSaveButton:test__should_subtract_values_from_save_active_state__when_save_active_is_above_zero()
    editor.save_button.has_been_pressed = editor.save_button.has_been_pressed_max
    local first_value = editor.save_button.has_been_pressed

    editor.update_save_button()

    local second_value = editor.save_button.has_been_pressed

    luaunit.assertTrue(first_value > second_value)
end


function TestUpdateSaveButton:test__should_not_subtract_values_from_save_active_state__when_save_active_is_not_above_zero()
    editor.save_button.has_been_pressed = 0
    local first_value = editor.save_button.has_been_pressed

    editor.update_save_button()

    local second_value = editor.save_button.has_been_pressed

    luaunit.assertTrue(first_value == second_value)
end


--[[ End of TestUpdateSaveButton ]]


--[[ Start of TestHandlePressingUniversalButtons ]]

TestHandlePressingUniversalButtons = {}


function TestHandlePressingUniversalButtons:setUp()
    -- Since we don't start Love2D window, then we can't scale gamepixels.
    g.screen.gamepixel.w = 1
    g.screen.gamepixel.h = 1
    g.sprites.path = g.sprites.path_test
    g.sprites.sprites = sprite.get_all_sprites()
end


function TestHandlePressingUniversalButtons:test__shold_set_tab_to_the_first_one__when_mouse_over_first_tab_button()
    editor.current_tab = 2
    local x = editor.all_sprites_tab_1.x + 4
    local y = editor.all_sprites_tab_1.y + 4

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 1)
end


function TestHandlePressingUniversalButtons:test__should_set_tab_to_the_first_one__when_mouse_over_top_left_corner_of_the_first_tab_button()
    editor.current_tab = 2
    local x = editor.all_sprites_tab_1.x
    local y = editor.all_sprites_tab_1.y

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 1)
end


function TestHandlePressingUniversalButtons:test__should_set_tab_to_the_first_one__when_mouse_over_bottom_right_corner_of_the_first_tab_button()
    editor.current_tab = 2
    local x = editor.all_sprites_tab_1.x + editor.all_sprites_tab_1.w
    local y = editor.all_sprites_tab_1.y + editor.all_sprites_tab_1.h

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 1)
end


function TestHandlePressingUniversalButtons:test__shold_set_tab_to_the_second_one__when_mouse_over_second_tab_button()
    editor.current_tab = 1
    local x = editor.all_sprites_tab_2.x + 4
    local y = editor.all_sprites_tab_2.y + 4

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 2)
end


function TestHandlePressingUniversalButtons:test__shold_set_tab_to_the_third_one__when_mouse_over_third_tab_button()
    editor.current_tab = 1
    local x = editor.all_sprites_tab_3.x + 4
    local y = editor.all_sprites_tab_3.y + 4

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 3)
end


-- This test actually fails – it switches to second tab instead of to the third tab.
-- It is something I would like to investigate, but it's tatally unnoticeable
-- when actually using the software – so, low prio.
function TestHandlePressingUniversalButtons:test__should_set_tab_to_the_third_one__when_mouse_over_top_left_corner_of_the_third_tab_button()
    editor.current_tab = 1
    local x = editor.all_sprites_tab_3.x
    local y = editor.all_sprites_tab_3.y

    editor.handle_mousepresses(x, y, 1)

    print("This test actually fails - it switches to second tab instead of to the third tab.")
    print("It is something I would like to investigate, but it's tatally unnoticeable")
    print("when actually using the software – so, low prio.")
    luaunit.assertEquals(editor.current_tab, 3)
end


function TestHandlePressingUniversalButtons:test__should_set_tab_to_the_third_one__when_mouse_over_top_left_corner_of_the_third_tab_button_plus_1px_x_offset()
    editor.current_tab = 1
    local x = editor.all_sprites_tab_3.x + 1
    local y = editor.all_sprites_tab_3.y

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 3)
end


function TestHandlePressingUniversalButtons:test__should_set_tab_to_the_third_one__when_mouse_over_bottom_right_corner_of_the_third_tab_button()
    editor.current_tab = 1
    local x = editor.all_sprites_tab_3.x + editor.all_sprites_tab_3.w
    local y = editor.all_sprites_tab_3.y + editor.all_sprites_tab_3.h

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_tab, 3)
end


function TestHandlePressingUniversalButtons:test__should_set_current_color_to_blue_bold__when_mouse_is_over_blue_bold_coords()
    luaunit.assertEquals(editor.colors[10][1], palette.blue_bold)
    local x = editor.colors[10][2] + 2
    local y = editor.colors[10][3] + 2

    editor.handle_mousepresses(x, y, 1)

    luaunit.assertEquals(editor.current_color, 10)
end


--[[ End of TestHandlePressingUniversalButtons ]]


os.exit(luaunit.LuaUnit.run())
