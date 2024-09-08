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

return utils
