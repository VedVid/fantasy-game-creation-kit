require "api"

local g = require "globals"
local s = require "sprite"


local editor = {}

editor.current_tab = 1
editor.current_sprite = 1

editor.colors = {
	{Black, 150, 30},
	{BlackBold, 158, 30},
	{Blue, 166, 30},
	{BlueBold, 174, 30},
	{Cyan, 150, 38},
	{CyanBold, 158, 38},
	{Green, 166, 38},
	{GreenBold, 174, 38},
	{Pink, 150, 46},
	{PinkBold, 158, 46},
	{Red, 166, 46},
	{RedBold, 174, 46},
	{Yellow, 150, 54},
	{YellowBold, 158, 54},
	{White, 166, 54},
	{WhiteBold, 174, 54}
}

function editor.set_current_tab(num)
	editor.current_tab = num
end

function editor.set_current_sprite(sprite_num)
	editor.current_sprite = sprite_num
end

function editor.draw_all_sprites()
	local cols = 30
	local rows = 6
	local tab = editor.current_tab

	local start = 0
	if tab > 1 then
		start = cols * rows * (tab - 1)
		-- start = start - 1 ???
	end

	local x = g.sprites.size_w
	local y = 192 - ((rows + 1) * g.sprites.size_h)
	-- 192 is arbitrarily set number, innit?

	for i=1, cols*rows do
		local sprite_number = start + i
		if sprite_number > g.sprites.amount then
			break
		end
		Spr(start + i, x, y)
		x = x + g.sprites.size_w
		if x >= g.screen.size.gamepixels.w - (1.5 * g.sprites.size_w) then
			x = g.sprites.size_w
			y = y + g.sprites.size_h
		end
	end
end

function editor.draw_current_sprite()
	local sprite = editor.current_sprite
	local start_x = g.sprites.size_w
	local start_y = 30
	local cols = 8  -- every sprite is 8x8, so we wrap after 8th column every time
	local col = 0
	local row = 0
	local real_sprite = s.get_sprite(sprite)
	local sprite_colors = s.return_sprite_colors(real_sprite, "rgb01", true)
	for i, v in ipairs(sprite_colors) do
		if i % cols == 0 then
			col = 0
			row = row + 1
		end
		local cur_x = start_x + (col * g.sprites.size_w)
		local cur_y = start_y + (row * g.sprites.size_h)
		Rectfill(
			cur_x,
			cur_y,
			g.sprites.size_w,
			g.sprites.size_h,
			v
		)
	end
end

function editor.draw_colors()
	for _, v in ipairs(editor.colors) do
		Rectfill(v[2], v[3], g.sprites.size_w, g.sprites.size_h, v[1])
	end
end

return editor
