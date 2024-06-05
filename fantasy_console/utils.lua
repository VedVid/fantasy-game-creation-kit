local utils = {}

function utils.check_if_string_is_valid_ascii(s)
    local tmp = string.gsub(s, "[\128-\255]", "")
    return tmp == s
end

return utils
