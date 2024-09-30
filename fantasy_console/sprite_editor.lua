require "api"

local g = require "globals"
local s = require "sprite"
local palette = require "palette"
local utils = require "utils"


local editor = {}

editor.modes = {}
editor.modes.point = "point"
editor.modes.line = "line"
editor.modes.rect = "rect"
editor.modes.rectfill = "rectfill"
editor.modes.circ = "circ"
editor.modes.circfill = "circfill"
editor.modes.oval = "oval"
editor.modes.ovalfill = "ovalfill"
editor.toggle = {}
editor.toggle.press = "press"
editor.toggle.hold = "hold"

editor.current_tab = 1
editor.current_sprite = 1
editor.current_color = 1
editor.current_mode = editor.modes.point
editor.current_toggle = editor.toggle.hold

-- When user changes sprite by drawing, then the changes should be
-- automatically added to current_sprite_data
editor.current_sprite_data = nil
-- ^^^ number: <number>, rgb01: <table of numbers>, hex: <string>

editor.colors_x_start = 152
editor.colors_y_start = 30
editor.current_sprite_x_start = 45
editor.current_sprite_y_start = 30
editor.current_sprite_border_color = Cyan
editor.all_sprites_x_start = 8
editor.all_sprites_y_start = 192

editor.save_button = {}
editor.save_button.w = 25
editor.save_button.h = 11
editor.save_button.x = editor.colors_x_start + (g.sprites.size_w * 4) - editor.save_button.w - 7
editor.save_button.y = editor.colors_y_start + (g.sprites.size_h * 4) + editor.save_button.h - 8
editor.save_button.border_color = Cyan
editor.save_button.border_color_active = PinkBold
editor.save_button.background_color = BlackBold
editor.save_button.background_color_active = WhiteBold
editor.save_button.has_been_pressed = 0
editor.save_button.has_been_pressed_max = math.floor(g.min_dt * 1000)
editor.save_button.text = "Save"
editor.save_button.text_active = "Saved!"

editor.toggle_button = {}
editor.toggle_button.w = 45
editor.toggle_button.h = 11
editor.toggle_button.x = editor.colors_x_start + (g.sprites.size_w * 4) - editor.toggle_button.w + 13
editor.toggle_button.y = editor.colors_y_start + (g.sprites.size_h * 4) + editor.toggle_button.h + 6
editor.toggle_button.border_color = Cyan
editor.toggle_button.accent_color = PinkBold
editor.toggle_button.background_color = BlackBold
editor.toggle_button.text = "click or hold"

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
	{palette.black, editor.colors_x_start, editor.colors_y_start},
	{palette.black_bold, editor.colors_x_start + 8, editor.colors_y_start},
	{palette.red, editor.colors_x_start + 16, editor.colors_y_start},
	{palette.red_bold, editor.colors_x_start + 24, editor.colors_y_start},
	{palette.green, editor.colors_x_start, editor.colors_y_start + 8},
	{palette.green_bold, editor.colors_x_start + 8, editor.colors_y_start + 8},
	{palette.yellow, editor.colors_x_start + 16, editor.colors_y_start + 8},
	{palette.yellow_bold, editor.colors_x_start + 24, editor.colors_y_start + 8},
	{palette.blue, editor.colors_x_start, editor.colors_y_start + 16},
	{palette.blue_bold, editor.colors_x_start + 8, editor.colors_y_start + 16},
	{palette.magenta, editor.colors_x_start + 16, editor.colors_y_start + 16},
	{palette.magenta_bold, editor.colors_x_start + 24, editor.colors_y_start + 16},
	{palette.cyan, editor.colors_x_start, editor.colors_y_start + 24},
	{palette.cyan_bold, editor.colors_x_start + 8, editor.colors_y_start + 24},
	{palette.white, editor.colors_x_start + 16, editor.colors_y_start + 24},
	{palette.white_bold, editor.colors_x_start + 24, editor.colors_y_start + 24}
}

function editor.set_current_tab(num)
	s.set_sprite(editor.current_sprite, editor.current_sprite_data)
	editor.current_tab = num
end

function editor.set_current_sprite(num)
	if editor.current_sprite_data == nil then
		editor.current_sprite_data = s.return_sprite_colors(
			s.get_sprite(editor.current_sprite), "palette"
		)
	end
	s.set_sprite(editor.current_sprite, editor.current_sprite_data)
	editor.current_sprite = num
	editor.current_sprite_data = s.return_sprite_colors(
		s.get_sprite(editor.current_sprite), "palette"
	)
	-- ^^^ number: <number>, rgb01: <table of numbers>, hex: <string>
end

function editor.set_current_color(num)
	editor.current_color = num
end

function editor.set_current_toggle_mode()
	if editor.current_toggle == editor.toggle.hold then
		editor.current_toggle = editor.toggle.press
	else 
		editor.current_toggle = editor.toggle.hold
	end
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

	if sprite_border.x then
		Rect(sprite_border.x, sprite_border.y, g.sprites.size_w + 2, g.sprites.size_h + 2, PinkBold)
	end
end

function editor.draw_current_sprite()
	local col = 0
	local row = 0

	if editor.current_sprite_data == nil then
		editor.current_sprite_data = s.return_sprite_colors(
			s.get_sprite(editor.current_sprite), "palette"
		)
	end

	Rect(
		editor.current_sprite_x_start - 1,
		editor.current_sprite_y_start - 1,
		(g.sprites.size_w ^ 2) + 2,
		(g.sprites.size_h ^ 2) + 2,
		Cyan
	  )

	for _, line in ipairs(editor.current_sprite_data) do
	local cur_y = editor.current_sprite_y_start + (row * g.sprites.size_h)
		for _, v in ipairs(line) do
			local cur_x = editor.current_sprite_x_start + (col * g.sprites.size_w)
			Rectfill(
				cur_x,
				cur_y,
				g.sprites.size_w,
				g.sprites.size_h,
				v["rgb01"]
			)
			col = col + 1
		end
		col = 0
		row = row + 1
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
		Rectfill(v[2], v[3], g.sprites.size_w, g.sprites.size_h, v[1]["rgb01"])
	end
	Rect(
		editor.colors[editor.current_color][2]-1,
		editor.colors[editor.current_color][3]-1,
		g.sprites.size_w + 2,
		g.sprites.size_h + 2,
		PinkBold
	)
end

function editor.draw_save_button()
	local border_color = editor.save_button.border_color
	local background_color = editor.save_button.background_color
	local text = editor.save_button.text
	if editor.save_button.has_been_pressed > 0 then
		border_color = editor.save_button.border_color_active
		background_color = editor.save_button.background_color_active
		text = editor.save_button.text_active
	end
	Rect(
		editor.save_button.x - 1,
		editor.save_button.y - 1,
		editor.save_button.w + 2,
		editor.save_button.h + 2,
		border_color
	)
	Rectfill(
		editor.save_button.x,
		editor.save_button.y,
		editor.save_button.w,
		editor.save_button.h,
		background_color
	)
	Write(text, editor.save_button.x + 2, editor.save_button.y + 2)
end

function editor.draw_toggle_button()
	Rect(
		editor.toggle_button.x - 1,
		editor.toggle_button.y - 1,
		editor.toggle_button.w + 2,
		editor.toggle_button.h + 2,
		editor.toggle_button.border_color
	)
	Rectfill(
		editor.toggle_button.x,
		editor.toggle_button.y,
		editor.toggle_button.w,
		editor.toggle_button.h,
		editor.toggle_button.background_color
	)
	Write(editor.toggle_button.text, editor.toggle_button.x + 2, editor.toggle_button.y + 2)
	local button_x_offset_start = 1
	local button_x_offset_end = 16
	if editor.current_toggle == editor.toggle.hold then
		button_x_offset_start = 27
		button_x_offset_end = 42
	end
	Line(
		editor.toggle_button.x + button_x_offset_start,
		editor.toggle_button.y + 9,
		editor.toggle_button.x + button_x_offset_end,
		editor.toggle_button.y + 9,
		editor.toggle_button.accent_color
	)
end

function editor.update_save_button()
	print(editor.save_button.has_been_pressed)
	if editor.save_button.has_been_pressed > 0 then
		editor.save_button.has_been_pressed = editor.save_button.has_been_pressed - 1
	end
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

function editor.handle_pressing_universal_buttons(x, y)
	-- This could be probably improved by basic bound checking
	-- around the tabs and colors, instead of iterating over all
	-- buttons from the very start.

	-- Check if mouse is over tab buttons.
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

	-- Check if mouse is over list of colors.
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

	-- Check if mouse is over save button.
	if utils.mouse_box_bound_check(
		x,
		editor.save_button.x * g.screen.gamepixel.w,
		(editor.save_button.x + editor.save_button.w) * g.screen.gamepixel.w,
		y,
		editor.save_button.y * g.screen.gamepixel.h,
		(editor.save_button.y + editor.save_button.h) * g.screen.gamepixel.h
	) then
		s.set_sprite(editor.current_sprite, editor.current_sprite_data)
		editor.save_button.has_been_pressed = editor.save_button.has_been_pressed_max
	end

	-- Check if mouse is over toggle button.
	if utils.mouse_box_bound_check(
		x,
		editor.toggle_button.x * g.screen.gamepixel.w,
		(editor.toggle_button.x + editor.toggle_button.w) * g.screen.gamepixel.w,
		y,
		editor.toggle_button.y * g.screen.gamepixel.h,
		(editor.toggle_button.y + editor.toggle_button.h) * g.screen.gamepixel.h
	) then
		editor.set_current_toggle_mode()
	end

	-- Check if mouse is over sprites list.
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
			editor.set_current_sprite(current_sprite_temp)
			return
		else
			editor.set_current_sprite(
				(((row - 1) * 30) + col) + (180 * (editor.current_tab - 1))
			)
			return
		end
	end
end

function editor.handle_mouseholding(x, y)
	-- This closure is used later to use within pcall to emulate
	-- behaviour similar to try-except
	local function replace_sprite_pixel(sprite_1_x, sprite_1_y)
		g.sprites.sprites[editor.current_sprite]["colors"][sprite_1_y][sprite_1_x] = editor.colors[editor.current_color][1]
	end

	if love.mouse.isDown(1, 2) then
		-- Check if mouse is over current sprite.
		if utils.mouse_box_bound_check(
			x,
			editor.current_sprite_x_start * g.screen.gamepixel.w,
			(editor.current_sprite_x_start + (8 * g.sprites.size_w)) * g.screen.gamepixel.w,
			y,
			editor.current_sprite_y_start * g.screen.gamepixel.h,
			(editor.current_sprite_y_start + (8 * g.sprites.size_h)) * g.screen.gamepixel.h
		) then
			-- Again, lots of magic below, and I don't really like it.
			-- 1. We get x and y; these are raw pixel mouse coords caught by Love2D
			-- 2. We divide the coords by g.screen.gamepixel.w / .h to obtain
			--    the correct resolution in gamepixels.
			-- 3. We substract distance of the currently drawn sprite from the left and top
			--    edges of screen. These values are in gamepixels already.
			-- 4. We divide result by g.sprites.size_w / _h, because cells have size
			--    of full sprite.
			-- 5. We use math.ceil function to round the results up, because
			--    the first sprite has coords from 0.1 to 1.0.
			local sprite_x = math.ceil(((x / g.screen.gamepixel.w) - editor.current_sprite_x_start) / g.sprites.size_w)
			local sprite_y = math.ceil(((y / g.screen.gamepixel.h) - editor.current_sprite_y_start) / g.sprites.size_h)
			if editor.current_mode == editor.modes.point then
				local ok, res = pcall(replace_sprite_pixel, sprite_x, sprite_y)
				if not ok then
					print("Warning: " .. res)
				end
			end
		end
	end
end


function editor.handle_mousepresses(x, y)
	-- This closure is used later to use within pcall to emulate
	-- behaviour similar to try-except
	local function replace_sprite_pixel(sprite_1_x, sprite_1_y)
		g.sprites.sprites[editor.current_sprite]["colors"][sprite_1_y][sprite_1_x] = editor.colors[editor.current_color][1]
		end

	-- Check if mouse is over current sprite.
	if utils.mouse_box_bound_check(
		x,
		editor.current_sprite_x_start * g.screen.gamepixel.w,
		(editor.current_sprite_x_start + (8 * g.sprites.size_w)) * g.screen.gamepixel.w,
		y,
		editor.current_sprite_y_start * g.screen.gamepixel.h,
		(editor.current_sprite_y_start + (8 * g.sprites.size_h)) * g.screen.gamepixel.h
	) then
		-- Again, lots of magic below, and I don't really like it.
		-- 1. We get x and y; these are raw pixel mouse coords caught by Love2D
		-- 2. We divide the coords by g.screen.gamepixel.w / .h to obtain
		--    the correct resolution in gamepixels.
		-- 3. We substract distance of the currently drawn sprite from the left and top
		--    edges of screen. These values are in gamepixels already.
		-- 4. We divide result by g.sprites.size_w / _h, because cells have size
		--    of full sprite.
		-- 5. We use math.ceil function to round the results up, because
		--    the first sprite has coords from 0.1 to 1.0.
		local sprite_x = math.ceil(((x / g.screen.gamepixel.w) - editor.current_sprite_x_start) / g.sprites.size_w)
		local sprite_y = math.ceil(((y / g.screen.gamepixel.h) - editor.current_sprite_y_start) / g.sprites.size_h)
		if editor.current_mode == editor.modes.point then
			local ok, res = pcall(replace_sprite_pixel, sprite_x, sprite_y)
			if not ok then
				print("Warning: " .. res)
			end
		end
	end
end

return editor
