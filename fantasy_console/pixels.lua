local colors = require "colors"

local pixels = {}

pixels.default_color = colors.black

function pixels.new_pixel(color)
    local pixel = {}
    pixel.color = color
    if not pixel.color then
        pixel.color = pixels.default_color
    end
    return pixel
end

return pixels
