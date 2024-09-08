require "api"

local g = require "globals"
local s = require "sprite"
local utils = require "utils"


local editor = {}

editor.current_tab = 1
editor.current_sprite = 1

editor.colors_x_start = 152
editor.colors_y_start = 30
editor.current_sprite_x_start = 45
editor.current_sprite_y_start = 30
editor.all_sprites_x_start = 8
editor.all_sprites_y_start = 192

editor.tab_buttons = {}
editor.tab_buttons.border_color = Cyan
editor.tab_buttons.border_color_active = PinkBold
editor.tab_buttons.background_color = BlackBold
editor.tab_buttons.background_color_active = WhiteBold
editor.tab_buttons.buttons = {}
editor.all_sprites_tab_1 = {}
editor.all_sprites_tab_1.w = 21
editor.all_sprites_tab_1.h = 11
editor.all_sprites_tab_1.x = editor.all_sprites_x_start + 4
editor.all_sprites_tab_1.y = editor.all_sprites_y_start - 67
editor.all_sprites_tab_1.txt = "Tab 1"
table.insert(editor.tab_buttons.buttons, editor.all_sprites_tab_1)
editor.all_sprites_tab_2 = {}
editor.all_sprites_tab_2.w = 21
editor.all_sprites_tab_2.h = 11
editor.all_sprites_tab_2.x = editor.all_sprites_tab_1.x + editor.all_sprites_tab_1.w
editor.all_sprites_tab_2.y = editor.all_sprites_y_start - 67
editor.all_sprites_tab_2.txt = "Tab 2"
table.insert(editor.tab_buttons.buttons, editor.all_sprites_tab_2)
editor.all_sprites_tab_3 = {}
editor.all_sprites_tab_3.w = 21
editor.all_sprites_tab_3.h = 11
editor.all_sprites_tab_3.x = editor.all_sprites_tab_2.x + editor.all_sprites_tab_2.w
editor.all_sprites_tab_3.y = editor.all_sprites_y_start - 67
editor.all_sprites_tab_3.txt = "Tab 3"
table.insert(editor.tab_buttons.buttons, editor.all_sprites_tab_3)


editor.colors = {
	{Black, editor.colors_x_start, editor.colors_y_start},
	{BlackBold, editor.colors_x_start + 8, editor.colors_y_start},
	{Blue, editor.colors_x_start + 16, editor.colors_y_start},
	{BlueBold, editor.colors_x_start + 24, editor.colors_y_start},
	{Cyan, editor.colors_x_start, editor.colors_y_start + 8},
	{CyanBold, editor.colors_x_start + 8, editor.colors_y_start + 8},
	{Green, editor.colors_x_start + 16, editor.colors_y_start + 8},
	{GreenBold, editor.colors_x_start + 24, editor.colors_y_start + 8},
	{Pink, editor.colors_x_start, editor.colors_y_start + 16},
	{PinkBold, editor.colors_x_start + 8, editor.colors_y_start + 16},
	{Red, editor.colors_x_start + 16, editor.colors_y_start + 16},
	{RedBold, editor.colors_x_start + 24, editor.colors_y_start + 16},
	{Yellow, editor.colors_x_start, editor.colors_y_start + 24},
	{YellowBold, editor.colors_x_start + 8, editor.colors_y_start + 24},
	{White, editor.colors_x_start + 16, editor.colors_y_start + 24},
	{WhiteBold, editor.colors_x_start + 24, editor.colors_y_start + 24}
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

	local x = editor.all_sprites_x_start
	local y = editor.all_sprites_y_start - ((rows + 1) * g.sprites.size_h)

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
	local cols = 8  -- every sprite is 8x8, so we wrap after 8th column every time
	local col = 0
	local row = 0
	local real_sprite = s.get_sprite(sprite)
	local sprite_colors = s.return_sprite_colors(real_sprite, "rgb01")

	for _, rgb_color_table in ipairs(sprite_colors) do
		local cur_x = editor.current_sprite_x_start + (col * g.sprites.size_w)
		local cur_y = editor.current_sprite_y_start+ (row * g.sprites.size_h)
		Rectfill(
			cur_x,
			cur_y,
			g.sprites.size_w,
			g.sprites.size_h,
			rgb_color_table
		)
		col = col + 1
		if col % cols == 0 then
			col = 0
			row = row + 1
		end
	end
end

function editor.draw_colors()
	for _, v in ipairs(editor.colors) do
		Rectfill(v[2], v[3], g.sprites.size_w, g.sprites.size_h, v[1])
	end
	Rect(
	  editor.colors_x_start - 1,
	  editor.colors_y_start - 1,
	  (g.sprites.size_w * 4) + 2,
	  (g.sprites.size_h * 4) + 2,
	  Cyan
	)
end

function editor.draw_spritesheet_buttons()
	for i, button in ipairs(editor.tab_buttons.buttons) do
		local border_color = editor.tab_buttons.border_color
		local background_color = editor.tab_buttons.background_color
		if i == editor.current_tab then
			border_color = editor.tab_buttons.border_color_active
			background_color = editor.tab_buttons.background_color_active
		end
		Rectfill(
			button.x,
			button.y,
			button.w,
			button.h,
			background_color
		)
		Line(
			button.x,
			button.y,
			button.x + button.w - 1,
			button.y,
			border_color)
		Write(button.txt, button.x + 2, button.y + 3)
	end
end

function editor.handle_mousepresses(x, y, mousebutton)
	for  i, button in ipairs(editor.tab_buttons.buttons) do
		if utils.mouse_box_bound_check(
			x,
			button.x * g.screen.gamepixel.w,
			(button.x + button.w) * g.screen.gamepixel.w,
			y,
			button.y * g.screen.gamepixel.h,
			(button.y + button.h) * g.screen.gamepixel.h
		) then
			editor.current_tab = i
			return
		end
	end
end

return editor
