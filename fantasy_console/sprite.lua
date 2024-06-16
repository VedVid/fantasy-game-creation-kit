local cartdata = require "_cartdata"
local g = require "globals"

local sprite = {}

sprite.default_color = g.colors.default_bg_color

function sprite.new_sprite()
	local new_sprite = {}
	new_sprite.colors = {}
	for y = 1, 8 do
		local tmp_colors = {}
		for x = 1, 8 do
			table.insert(tmp_colors, sprite.default_color)
		end
		table.insert(new_sprite.colors, tmp_colors)
	end
	return new_sprite()
end

function sprite.set_pixel_color(sprite_no, pix_x, pix_y, color)
	-- tables are passed as reference, so it should update, not?
	local sprite = sprite.get_sprite_from_cartdata(sprite_no)
	sprite.colors[pix_x][pix_y] = color
end

function sprite.get_sprite_from_cartdata(sprite)
	return cartdata.sprites[sprite]
end
