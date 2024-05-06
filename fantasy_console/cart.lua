local sprites = require "sprites"

local cart = {}

cart.code = ""

cart.sprites = {}
cart.sprites_max = 512
for i=1,cart.sprites_max do
    cart.sprites[i] = sprites.new_sprite()
end

--cart.map = {}
--cart.map_w = 1024
--cart.map_h = 1024
--for i=1,cart.map_h*cart.map_h do
--    cart.map[i] = nil
--end

return cart
