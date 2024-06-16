local data_sprites = require "data/sprites"
local g = require "globals"

local sprite = {}

sprite.default_color = g.colors.default_bg_color

function sprite.new_blank_sprite()
	local new_sprite = {}
	new_sprite.colors = {}
	for y = 1, 8 do
		local tmp_colors = {}
		for x = 1, 8 do
			table.insert(tmp_colors, sprite.default_color)
		end
		table.insert(new_sprite.colors, tmp_colors)
	end
	return new_sprite
end

function sprite.set_pixel_color(sprite_no, pix_x, pix_y, color)
	-- tables are passed as reference, so it should update, not?
	local spr = sprite.get_sprite_from_cartdata(sprite_no)
	spr.colors[pix_x][pix_y] = color
end

function sprite.get_sprite_from_cartdata(spr)
	return data_sprites.sprites[spr]
end


function sprite.initialize_blank_sprites()
	local tmp_table = {}
	for i = 1, g.sprites_amount do
		local spr = sprite.new_blank_sprite()
		table.insert(tmp_table, spr)
	end
	local s = "local data = {}\n\n" .. tmp_table .. "\n\nreturn data\n"
	local f = io.open("data/sprites.lua", "w")
	if f then
		f:write(s)
		f:close()
	end
end

return sprite
