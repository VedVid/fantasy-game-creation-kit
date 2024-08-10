--local data_sprites = require "data/sprites"
local json = require "json"
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

--function sprite.set_pixel_color(sprite_no, pix_x, pix_y, color)
--	-- tables are passed as reference, so it should update, not?
--	local spr = sprite.get_sprite_from_cartdata(sprite_no)
--	spr.colors[pix_x][pix_y] = color
--end

function sprite.get_sprite(num)
	return sprite.get_all_sprites()[num]
end

function sprite.get_all_sprites()
	local f = assert(io.open(g.sprites_path, "r"))
	local t = f:read("*all")
	io.close(f)
	local lua_sprite_table = json.decode(t)
	return lua_sprite_table
end

function sprite.initialize_blank_sprites()
	local tmp_table = {}
	for i = 1, g.sprites_amount do
		local spr = sprite.new_blank_sprite()
		table.insert(tmp_table, spr)
	end
	local json_sprite_table = json.encode(tmp_table)
	-- !! DANGEROUS – it'll remove all data in sprites.json!
	local f = assert(io.open(g.sprites_path, "w+"))
	io.output(f)
	io.write(json_sprite_table)
	io.close(f)
end

return sprite
