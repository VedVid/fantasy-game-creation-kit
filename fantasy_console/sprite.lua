--local data_sprites = require "data/sprites"
local json = require "json"
local g = require "globals"

local sprite = {}

sprite.default_color = g.colors.default_bg_color

--function sprite.set_pixel_color(sprite_no, pix_x, pix_y, color)
--	-- tables are passed as reference, so it should update, not?
--	local spr = sprite.get_sprite_from_cartdata(sprite_no)
--	spr.colors[pix_x][pix_y] = color
--end

function sprite.get_sprite(num)
	--[[
    Method get_sprite returns sprite from the sprites.json.

    Arguments
    ---------
    num : number
	    The number indicating the location of the sprite that
		we want to return in order from the beginning
		of the sprites.json file.

    Returns
    -------
    sprite
    ]]--

	if num <= 0 then
		error("Invalid sprite number: " .. num .. " is smaller than 1.")
	elseif num > g.sprites_amount then
		error("Invalid sprite number: " .. num .. " is larger than total number of sprites (" .. g.sprites_amount .. ")")
	end

	return sprite.get_all_sprites()[num]
end

function sprite.get_all_sprites()
	--[[
    Method get_all_sprites decodes (using json library by rxi)
	sprites.json file and returns it.

    Arguments
    ---------
    none

    Returns
    -------
    table of sprites
    ]]--

	local f = assert(io.open(g.sprites_path, "r"))
	local t = f:read("*all")
	io.close(f)
	local lua_sprite_table = json.decode(t)
	return lua_sprite_table
end

function sprite.new_blank_sprite()
	--[[
    Method new_blank_sprite creates blank sprite – ie, 8x8 sprite
	with all pixels in sprite's default_color (which equals to
    default_bg_color).
	It is used by sprite.initialize_blank_sprites when json file
	with sprites is created.

    Arguments
    ---------
    none

    Returns
    -------
    sprite
    ]]--

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

function sprite.initialize_blank_sprites()
	--[[
    Method initialize_blank_sprites, using new_blank_sprite
	method, a table that consists of amount specified in sprites_amount
	global variable of blank sprites, when necessary
	(so, when colors.json does not exist and needs to be created).

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

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

function sprite.print_sprite_colors(spr)
	--[[
    Method print_sprite_colors prints hex value of every pixel
	in specific sprite. Used only for debugging purposes.

    Arguments
    ---------
    num : number
	    The number indicating the location of the sprite that
		we want to return in order from the beginning
		of the sprites.json file.

    Returns
    -------
    nothing
    ]]--

	local colors = spr["colors"]
	for _, color in pairs(colors) do
		for _, v in pairs(color) do
			-- row
			for k, d in pairs(v) do
				if k == "hex" then
					print(d)
				end
			end
		end
		--print(color)
	end
end

return sprite
