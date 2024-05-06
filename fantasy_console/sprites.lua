local pixels = require "pixels"

local sprites = {}

sprites.w = 8
sprites.h = 8

function sprites.new_sprite(pixels)
    local sprite_ = {}
    sprite_.pixels = pixels
    if not sprite_.pixels then
        sprite_.pixels = {}
        for i=1,sprites.w*sprites.h do
            table.insert(sprite_.pixels, pixels.new_pixel())
        end
    end
    return sprite_
end

return sprites
