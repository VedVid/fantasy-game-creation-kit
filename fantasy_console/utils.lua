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


function utils.distance_between(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
end


function utils.experimental_deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[utils.experimental_deepcopy(orig_key, copies)] = utils.experimental_deepcopy(orig_value, copies)
            end
            setmetatable(copy, utils.experimental_deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


return utils
