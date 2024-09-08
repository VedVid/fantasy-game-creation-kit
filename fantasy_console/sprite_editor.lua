require "api"

local g = require "globals"
local s = require "sprite"
local utils = require "utils"


local editor = {}

editor.current_tab = 1
editor.current_sprite = 1
editor.current_color = 1

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
	{Red, editor.colors_x_start + 16, editor.colors_y_start},
	{RedBold, editor.colors_x_start + 24, editor.colors_y_start},
	{Green, editor.colors_x_start, editor.colors_y_start + 8},
	{GreenBold, editor.colors_x_start + 8, editor.colors_y_start + 8},
	{Yellow, editor.colors_x_start + 16, editor.colors_y_start + 8},
	{YellowBold, editor.colors_x_start + 24, editor.colors_y_start + 8},
	{Blue, editor.colors_x_start, editor.colors_y_start + 16},
	{BlueBold, editor.colors_x_start + 8, editor.colors_y_start + 16},
	{Pink, editor.colors_x_start + 16, editor.colors_y_start + 16},
	{PinkBold, editor.colors_x_start + 24, editor.colors_y_start + 16},
	{Cyan, editor.colors_x_start, editor.colors_y_start + 24},
	{CyanBold, editor.colors_x_start + 8, editor.colors_y_start + 24},
	{White, editor.colors_x_start + 16, editor.colors_y_start + 24},
	{WhiteBold, editor.colors_x_start + 24, editor.colors_y_start + 24}
}

function editor.set_current_tab(num)
	editor.current_tab = num
end

function editor.set_current_sprite(num)
	editor.current_sprite = num
end

function editor.set_current_color(num)
	editor.current_color = num
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

	local sprite_border = {}

	for i=1, cols*rows do
		local sprite_number = start + i
		if sprite_number > g.sprites.amount then
			break
		end
		Spr(start + i, x, y)
		if sprite_number == editor.current_sprite then
			sprite_border.x = x - 1
			sprite_border.y = y - 1
		end
		x = x + g.sprites.size_w
		if x >= g.screen.size.gamepixels.w - (1.5 * g.sprites.size_w) then
			x = g.sprites.size_w
			y = y + g.sprites.size_h
		end
	end

	Rect(sprite_border.x, sprite_border.y, g.sprites.size_w + 2, g.sprites.size_h + 2, PinkBold)
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
	Rect(
		editor.colors_x_start - 1,
		editor.colors_y_start - 1,
		(g.sprites.size_w * 4) + 2,
		(g.sprites.size_h * 4) + 2,
		Cyan
	  )
	for _, v in ipairs(editor.colors) do
		Rectfill(v[2], v[3], g.sprites.size_w, g.sprites.size_h, v[1])
	end
	Rect(
		editor.colors[editor.current_color][2]-1,
		editor.colors[editor.current_color][3]-1,
		g.sprites.size_w + 2,
		g.sprites.size_h + 2,
		Pink
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
	-- This could be probably improved by basic bound checking
	-- around the tabs and colors, instead of iterating over all
	-- buttons from the very start.

	for  i, button in ipairs(editor.tab_buttons.buttons) do
		if utils.mouse_box_bound_check(
			x,
			button.x * g.screen.gamepixel.w,
			(button.x + button.w) * g.screen.gamepixel.w,
			y,
			button.y * g.screen.gamepixel.h,
			(button.y + button.h) * g.screen.gamepixel.h
		) then
			editor.set_current_tab(i)
			return
		end
	end

	for i, color in ipairs(editor.colors) do
		if utils.mouse_box_bound_check(
			x,
			color[2] * g.screen.gamepixel.w,
			(color[2] + g.sprites.size_w) * g.screen.gamepixel.w,
			y,
			color[3] * g.screen.gamepixel.h,
			(color[3] + g.sprites.size_h) * g.screen.gamepixel.h
		) then
			editor.set_current_color(i)
			return
		end
	end

	if utils.mouse_box_bound_check(
		x,
		editor.all_sprites_x_start * g.screen.gamepixel.w,
		(editor.all_sprites_x_start + (30 * g.sprites.size_w)) * g.screen.gamepixel.w,
		y,
		(editor.all_sprites_y_start - (7 * g.sprites.size_h)) * g.screen.gamepixel.h,
		(editor.all_sprites_y_start - g.sprites.size_h) * g.screen.gamepixel.h
	) then
		-- There is definitely _too_ much magic in these two lines below,
		-- but I found it difficult to find a generic solution. The solution
		-- below is ugly and can cause issues during changing anything related
		-- to spritesheet location or form, but it works on every scale I tested it. 
		-- I'll try to explain how it works.
		-- 1. We get x and y; these are raw pixel mouse coords caught by Love2D
		-- 2. We dividing the coords by g.screen.gamepixel.w / .h to obtain
		--    the correct resolution in gamepixels.
		-- 3. Since we want to get columns and rows, and every sprite cell is equal
	    --    to g.sprites.size_w x g.sprites.size_h, we need to divide the
		--    coords in gamepixels divide by g.sprites.size_w / _h.
		-- 4. Columns span from the second tile from the edge, so we can leave that.
		-- 5. Rows are placed near the bottom from the screen, so we need to subtract
		--    amount of _rows_ from the top of the screen.
		-- 6. Finally, we truncate the results. So first tile instead of, said,
		--    1.95x1.35 returns 1x1
		local col = math.floor(x / g.screen.gamepixel.w / g.sprites.size_w)
		local row = math.floor((y / g.screen.gamepixel.h / g.sprites.size_h) - 16)
		if editor.current_tab == 3 then
			local current_sprite_temp = ((row - 1) * 30) + col + 360
			if current_sprite_temp > 512 then
				return
			end
			editor.current_sprite = current_sprite_temp
			return
		else
			editor.current_sprite = (((row - 1) * 30) + col) + (180 * (editor.current_tab - 1))
			return
		end
	end
end

return editor
