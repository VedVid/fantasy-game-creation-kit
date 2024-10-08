local g = require "globals"

local utils = {}

function utils.check_if_string_is_valid_ascii(s)
    local tmp = string.gsub(s, "[\128-\255]", "")
    return tmp == s
end

function utils.mouse_box_bound_check(x, x_min, x_max, y, y_min, y_max)
    return (
        x_min <= x and
        x_max >= x and
        y_min <= y and
        y_max >= y
    )
end

function utils.mouse_box_bound_check_for_buttons(x, y, button)
    return utils.mouse_box_bound_check(
        x,
        button.x * g.screen.gamepixel.w,
        (button.x + button.w) * g.screen.gamepixel.w,
        y,
        button.y * g.screen.gamepixel.h,
        (button.y + button.h) * g.screen.gamepixel.h
    )
end

return utils
