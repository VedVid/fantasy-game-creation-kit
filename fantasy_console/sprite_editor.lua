require "api"


local agcalc = require "api_geometry_calculations"
local agdraw = require "api_geometry_drawing"
local g = require "globals"
local s = require "sprite"
local palette = require "palette"
local utils = require "utils"


local editor = {}


-- List of the modes available to the user.
-- Mode is a way to draw, e.g. point is like
-- drawing pixel-by-pixel, like in Paint, and
-- rect will create a rectangle with two clicks.
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


-- This maps sprite editor modes to functions that calculate
-- coordinates of every point that creates a primitive.
editor.agcalc_modes_map = {}
editor.agcalc_modes_map[editor.modes.line] = agcalc.line
editor.agcalc_modes_map[editor.modes.rect] = agcalc.rect
editor.agcalc_modes_map[editor.modes.rectfill] = agcalc.rectfill
editor.agcalc_modes_map[editor.modes.circ] = agcalc.circ
editor.agcalc_modes_map[editor.modes.circfill] = agcalc.circfill
editor.agcalc_modes_map[editor.modes.oval] = agcalc.oval
editor.agcalc_modes_map[editor.modes.ovalfill] = agcalc.ovalfill


-- Helper variables used to track the current state of primitves drawing.
editor.drawing_primitives = false
-- ^^^ true if player is currently drawing a primitive
editor.anchor_primitive = nil
-- ^^ Anchor point – center of circle, top-left corner of rectangle, etc.
editor.primitive_args = nil
-- ^^ This is a list that keeps all arguments used in the calculating functions.
--    So, `x, y, w, h` for rectangle, `x, y, r` for circle, and so on.
--    They might keep the desired color of primitive drawn, too.
--    It is used because it is necessary to store these args somewhere
--    before the primitive is actually drawn, due to the dynamic nature of
--    drawing primitives (the preview is being re-drawn on every mouse move),
--    and sending these arguments around the whole sprite_editor file would
--    be cumberstone and would be less readable.
editor.primitive_coords = nil
-- ^^ List of all points that create a primitive.
--    Rationale is the same as for `primitive_args`.


-- Data related to tabs that are used to switch between pages of sprites list.
editor.current_tab = 1
editor.current_sprite = 1
editor.current_color = 1
editor.current_mode = editor.modes.point
editor.current_toggle = editor.toggle.hold


-- When user changes sprite by drawing, then the changes should be
-- automatically added to current_sprite_data
editor.current_sprite_data = nil
-- ^^^ number: <number>, rgb01: <table of numbers>, hex: <string>
editor.temp_sprite_data = nil
-- ^^^ number: <number>, rgb01: <table of numbers>, hex: <string>


-- Data relevant to drawing:
-- - list of colors to choose from
-- - current sprite view
-- - current sprite number
-- - list of all sprites
editor.colors_x_start = 152
editor.colors_y_start = 30
editor.current_sprite_x_start = 45
editor.current_sprite_y_start = 30
editor.current_sprite_info_x_start = editor.current_sprite_x_start
editor.current_sprite_info_y_start = editor.current_sprite_y_start + (8 * g.sprites.size_h) + 2
editor.all_sprites_x_start = 8
editor.all_sprites_y_start = 192


-- Save button.
-- It allows to save current work. After player taps the button,
-- it changes text and colors for a three seconds.
editor.save_button = {}
editor.save_button.w = 25
editor.save_button.h = 11
editor.save_button.x = editor.colors_x_start + (g.sprites.size_w * 4) - editor.save_button.w - 7
editor.save_button.y = editor.colors_y_start + (g.sprites.size_h * 4) + editor.save_button.h - 8
editor.save_button.has_been_pressed = 0
editor.save_button.has_been_pressed_max = math.floor(g.min_dt * 1000)
editor.save_button.text = "Save"
editor.save_button.text_active = "Saved!"


-- Kinda constants for sizing modes buttons.
editor.mode_buttons_w = 7
editor.mode_buttons_h = 7


---- Below there are data relevant to drawing mode buttons.
---- Buttons depends on each other – it means that if we change
---- e.g. the coordinates of the first button, the others will follow.
---- Pattern represents the figure that will be drawn over the button.
---- `0`s represent background, `1`s represent coloured pixel.
----
editor.point_mode_button = {}
editor.point_mode_button.name = editor.modes.point
editor.point_mode_button.w = editor.mode_buttons_w
editor.point_mode_button.h = editor.mode_buttons_h
editor.point_mode_button.x = editor.colors_x_start + (g.sprites.size_w * 4) - editor.point_mode_button.w - 25
editor.point_mode_button.y = editor.colors_y_start + (g.sprites.size_h * 4) + editor.point_mode_button.h + 10
editor.point_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.point_mode_button.pattern_color = Yellow

editor.line_mode_button = {}
editor.line_mode_button.name = editor.modes.line
editor.line_mode_button.w = editor.mode_buttons_w
editor.line_mode_button.h = editor.mode_buttons_h
editor.line_mode_button.x = editor.point_mode_button.x
editor.line_mode_button.y = editor.point_mode_button.y + editor.point_mode_button.h + 3
editor.line_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.line_mode_button.pattern_color = Yellow

editor.rect_mode_button = {}
editor.rect_mode_button.name = editor.modes.rect
editor.rect_mode_button.w = editor.mode_buttons_w
editor.rect_mode_button.h = editor.mode_buttons_h
editor.rect_mode_button.x = editor.point_mode_button.x + editor.point_mode_button.w + 3
editor.rect_mode_button.y = editor.point_mode_button.y
editor.rect_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 1, 0, 0, 0, 1, 0},
	{0, 1, 0, 0, 0, 1, 0},
	{0, 1, 0, 0, 0, 1, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.rect_mode_button.pattern_color = Yellow

editor.rectfill_mode_button = {}
editor.rectfill_mode_button.name = editor.modes.rectfill
editor.rectfill_mode_button.w = editor.mode_buttons_w
editor.rectfill_mode_button.h = editor.mode_buttons_h
editor.rectfill_mode_button.x = editor.point_mode_button.x + editor.point_mode_button.w + 3
editor.rectfill_mode_button.y = editor.line_mode_button.y
editor.rectfill_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.rectfill_mode_button.pattern_color = Yellow

editor.circ_mode_button = {}
editor.circ_mode_button.name = editor.modes.circ
editor.circ_mode_button.w = editor.mode_buttons_w
editor.circ_mode_button.h = editor.mode_buttons_h
editor.circ_mode_button.x = editor.rect_mode_button.x + editor.rect_mode_button.w + 3
editor.circ_mode_button.y = editor.rect_mode_button.y
editor.circ_mode_button.pattern = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 0, 0, 0, 1, 0},
	{1, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 1},
	{0, 1, 0, 0, 0, 1, 0},
	{0, 0, 1, 1, 1, 0, 0},
}
editor.circ_mode_button.pattern_color = Yellow

editor.circfill_mode_button = {}
editor.circfill_mode_button.name = editor.modes.circfill
editor.circfill_mode_button.w = editor.mode_buttons_w
editor.circfill_mode_button.h = editor.mode_buttons_h
editor.circfill_mode_button.x = editor.circ_mode_button.x
editor.circfill_mode_button.y = editor.rectfill_mode_button.y
editor.circfill_mode_button.pattern = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 0, 0},
}
editor.circfill_mode_button.pattern_color = Yellow

editor.oval_mode_button = {}
editor.oval_mode_button.name = editor.modes.oval
editor.oval_mode_button.w = editor.mode_buttons_w
editor.oval_mode_button.h = editor.mode_buttons_h
editor.oval_mode_button.x = editor.circ_mode_button.x + editor.circ_mode_button.w + 3
editor.oval_mode_button.y = editor.circ_mode_button.y
editor.oval_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 0, 0, 0, 1, 1},
	{1, 0, 0, 0, 0, 0, 1},
	{1, 1, 0, 0, 0, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.oval_mode_button.pattern_color = Yellow

editor.ovalfill_mode_button = {}
editor.ovalfill_mode_button.name = editor.modes.ovalfill
editor.ovalfill_mode_button.w = editor.mode_buttons_w
editor.ovalfill_mode_button.h = editor.mode_buttons_h
editor.ovalfill_mode_button.x = editor.oval_mode_button.x
editor.ovalfill_mode_button.y = editor.circfill_mode_button.y
editor.ovalfill_mode_button.pattern = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
}
editor.ovalfill_mode_button.pattern_color = Yellow
----
---- End of modes buttons data.
----


-- Tabs let user switch between pages / lists of sprites.
-- There are three tabs. The third is a little bit shorter than the first two.
editor.tab_buttons = {}
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


-- List of colors and the coordinates of the screen.
-- Together, all colors make a palette that user can choose colors
-- from by simply clicking on the color they wish to use.
-- It might seem to be redundant to color data
-- already available in `palette.lua` and `api.lua`, but this
-- form works better for sprite editor, because colors in
-- `api.lua` are just aliases to rgb01 values from palette,
-- and `palette.lua` contains much more data that is not necessary here.
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
	--[[
    Method set_current_tab calls set_sprite function that save lastly edited
	sprite data into editor.current_sprite_data that holds in memory all sprites,
	then saves everything file.
	Then, it sets current tab in the sprite editor.

	Arguments
	---------
	num : number
		Number of tab to switch. It should be in range between 1 to 3 (inclusive).

	Returns
	-------
	nothing
	]]--

	s.set_sprite(editor.current_sprite, editor.current_sprite_data)
	editor.current_tab = num
end


function editor.set_current_sprite(num)
	--[[
	This method is called when player clicks on any sprite cell in the list
	of the all sprites at the bottom half of the screen.

	At first, it ensures that current_sprite_data holds sprite data.
	It might be nil in some circumstances, especially after fresh app launch.
	Then it saves lastly edited sprites to json file (for details, please see comments
    to editor.set_current_tab).
	After that, it sets current sprite number, and loads this sprite data
	to current_sprite_data.

	Arguments
	---------
	num : number
		Number of chosen sprite.

	Returns
	-------
	nothing
	]]--

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
	--[[
	This function sets number of currently selected color.
	It is called when user clicks on any color on palette. Then, this color
	is used for drawing.

	Arguments
	---------
	num : number
		Numeric value that indicates color selected.

	Returns
	-------
	nothing
	]]--

	editor.current_color = num
end


function editor.set_current_mode(mode)
	--[[
    This function is called when player clicks on the button that changes
	drawing mode (like point, circle, line, etc.).
	It sets passed value mode to current_mode variable.

	Arguments
	---------
	mode : string
		`mode` value should be one of the values contained in `editor.modes` table.

	Returns
	-------
	nothing
	]]--

	editor.current_mode = mode
end


function editor.exit_drawing_primitives()
	--[[
	This function is called every time when user ends drawing a primitive.
	It does not matter if user cancelled drawing or confirmed changes. It only
	does a clean up.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	editor.drawing_primitives = false
	editor.primitive_args = nil
	editor.anchor_primitive = nil
end


function editor.switch_current_toggle_mode()
	--[[
	This function switches toggle mode, meaning: switches between introducing
	changes to current sprite when mouse is down (it allows to just hold mouse
    button down and draw things – in `point` mode only) and by requiring separate
	mouse presses (e.g. for rectangle – click once to anchor one corner, then
	click again in another place to draw the rectangle).
	`hold` mode is available only to `point` drawing.
	`press` mode is available to all drawing modes, except `point` drawing.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	if editor.current_mode == editor.modes.point then
		editor.current_toggle = editor.toggle.hold
		return
	end
	editor.current_toggle = editor.toggle.press
end


function editor.draw_all_sprites()
	--[[
	`draw_all_sprites` draws every sprite from the sprites.json file.
	While the list of sprites in the sprite editor consists of three tabs,
	it uses offset to show correct sprites.
	It also draws a border around currently selected sprite.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

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
		Spr(x, y, start + i)
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
	--[[
	This function draws enlarged version of currently selected sprite.
	It is enlarged to make editing sprite easier.
	If user in in drawing_primitives mode, then at the top of the current sprite,
	the preview of changes that are to be introduced is shown.
	Also, the border around the sprite is being drawn here.
	At the end of this function, drawing and re-drawing of preview of primitives
	is handled.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	local col = 0
	local row = 0

	Rect(
		editor.current_sprite_x_start - 1,
		editor.current_sprite_y_start - 1,
		(g.sprites.size_w ^ 2) + 2,
		(g.sprites.size_h ^ 2) + 2,
		Cyan
	  )

	if editor.current_sprite_data == nil then
		editor.current_sprite_data = s.return_sprite_colors(
			s.get_sprite(editor.current_sprite), "palette"
		)
	end

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

	if editor.drawing_primitives and editor.primitive_args then
		local primitive = editor.agcalc_modes_map[editor.current_mode](unpack(editor.primitive_args))
		local primitive_adjusted = {}
		editor.temp_sprite_data = nil
		editor.temp_sprite_data = utils.experimental_deepcopy(editor.current_sprite_data)
		for i, v in ipairs(primitive) do
			if v.x >= g.screen.gamepixel.w and v.x <= g.screen.gamepixel.w * 8 and v.y >= g.screen.gamepixel.h and v.y <= g.screen.gamepixel.h * 8 then
				table.insert(primitive_adjusted, v)
				editor.temp_sprite_data[v.y / g.screen.gamepixel.h][v.x / g.screen.gamepixel.w] = editor.colors[editor.current_color][1]
			end
		end
		love.graphics.push()
		love.graphics.translate(
			(editor.current_sprite_x_start - g.sprites.size_w) * g.screen.gamepixel.w,
			(editor.current_sprite_y_start - g.sprites.size_h) * g.screen.gamepixel.h
		)
		love.graphics.scale(g.sprites.size_w, g.sprites.size_h)
		agdraw.draw_with_pset(primitive_adjusted, editor.colors[editor.current_color][1])
		love.graphics.pop()
	end
end


function editor.write_current_sprite_number()
	--[[
	This function writes number of currently selected sprite under the
	current sprite view. It helps users to get sprite number to use it with
	Spr function.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	Write(
		editor.current_sprite_info_x_start,
		editor.current_sprite_info_y_start,
		"Current sprite: " .. editor.current_sprite,
		WhiteBold
	)
end


function editor.draw_colors()
	--[[
	This function iterates over the available palette colors and draws these
	colors on the screen to allow user to choose desired color to draw things.
	It also draws border around the whole palette, and smaller border
	around currently selected color.
	This function iterates over the editor.colors rather than over palette.lua
	values or API colors, because this table also specifies coordinates of every color
	on the sprite editor screen.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

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
	--[[
    Draws save button below the palette.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	local border_color = g.colors.default_button_border_color
	local background_color = g.colors.default_button_background_color
	local text = editor.save_button.text
	if editor.save_button.has_been_pressed > 0 then
		border_color = g.colors.default_button_border_color_active
		background_color = g.colors.default_button_background_color_active
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
	Write(editor.save_button.x + 2, editor.save_button.y + 2, text)
end


function editor.update_save_button()
	--[[
    When user uses Save button, then the Save button is for 3 seconds marked as active.
	It means that the border and background colors change, and `Save` text
	is replaced by `Saved!` for this time.
	It works that way to show user that the functionality works.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	if editor.save_button.has_been_pressed > 0 then
		editor.save_button.has_been_pressed = editor.save_button.has_been_pressed - 1
	end
end


function editor.draw_modes_buttons()
	--[[
	This function draws buttons that can be used to switch drawing modes,
	e.g. between point drawing to drawing circles or rectagles.
	Currently ony `point_mode_button` is shown to the player.
	]]--

	editor.draw_mode_button(editor.point_mode_button)
	editor.draw_mode_button(editor.line_mode_button)
	editor.draw_mode_button(editor.circ_mode_button)
	editor.draw_mode_button(editor.circfill_mode_button)
	editor.draw_mode_button(editor.rect_mode_button)
	editor.draw_mode_button(editor.rectfill_mode_button)
	editor.draw_mode_button(editor.oval_mode_button)
	editor.draw_mode_button(editor.ovalfill_mode_button)
end


function editor.draw_mode_button(button)
	--[[
	Generic function to draw every possible button for switching drawing modes
	that adheres to standards used in this file.
	Buttons that don't have all these fields will crash this function.

	Arguments
	---------
	button : button
		Every button passed to this function must have the following fields present:
			- x
			- y
			- w
			- h
			- pattern
			- pattern_color
		Other buttons will crash this function.

	Returns
	-------
	nothing
	]]--

	local border_color = g.colors.default_button_border_color
	local background_color = g.colors.default_button_background_color

	if editor.current_mode == button.name then
		border_color = g.colors.default_button_border_color_active
		background_color = g.colors.default_button_background_color_active
	end

	Rect(
		button.x - 1,
		button.y - 1,
		button.w + 2,
		button.h + 2,
		border_color
	)
	Rectfill(
		button.x,
		button.y,
		button.w,
		button.h,
		background_color
	)

	local x = button.x
	local y = button.y
	for _, row in ipairs(button.pattern) do
		for _, pixel in ipairs(row) do
			if pixel == 0 then
				do end
			elseif pixel == 1 then
				Pset(x, y, button.pattern_color)
			end
			x = x + 1
			if x > button.x + button.w - 1 then
				x = button.x
				y = y + 1
			end
		end
	end
end


function editor.draw_spritesheet_buttons()
	--[[
	Draws buttons at the top of the spritesheet list. Buttons are used to
	navigate between tabs. Switching tab saves current sprite.

	Arguments
	---------
	none

	Returns
	-------
	nothing
	]]--

	for i, button in ipairs(editor.tab_buttons.buttons) do
		local border_color = g.colors.default_button_border_color
		local background_color = g.colors.default_button_background_color
		if i == editor.current_tab then
			border_color = g.colors.default_button_border_color_active
			background_color = g.colors.default_button_background_color_active
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
		Write(button.x + 2, button.y + 3, button.txt)
	end
end


function editor.handle_mousepresses(x, y, button)
	--[[
	Handle mousepresses is function that:
	- iterates over color palette
	- checks spritesheet tabs and spritesheets itself
	- checks save button
	- checks buttons that trigger drawing mode change
	- checks starting primitive drawing
	- checks commiting primitive drawing
	It also exits primitive drawing on cancel and on commit.

	Arguments
	---------
	x : number
		mouse position on x ax; this value is passed from love.mousepressed
	y : number
		mouse position on y ax; this value is passed from love.mousepressed
	button : number
		mouse button; 1 is left mouse button, 2 is right mouse button

	Returns
	-------
	nothing
	]]--

	if button == 2 then
		editor.exit_drawing_primitives()
		return
	elseif button ~= 1 then
		return
	end

	-- This could be probably improved by basic bound checking
	-- around the tabs and colors, instead of iterating over all
	-- buttons from the very start.

	-- Check if mouse is over tab buttons.
	for  i, tab_button in ipairs(editor.tab_buttons.buttons) do
		if utils.mouse_box_bound_check_for_buttons(x, y, tab_button) then
			editor.set_current_tab(i)
			editor.exit_drawing_primitives()
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
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.save_button) then
		s.set_sprite(editor.current_sprite, editor.current_sprite_data)
		editor.save_button.has_been_pressed = editor.save_button.has_been_pressed_max
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over point mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.point_mode_button) then
		editor.set_current_mode(editor.modes.point)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over line mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.line_mode_button) then
		editor.set_current_mode(editor.modes.line)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over rect mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.rect_mode_button) then
		editor.set_current_mode(editor.modes.rect)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over rectfill mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.rectfill_mode_button) then
		editor.set_current_mode(editor.modes.rectfill)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over circ mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.circ_mode_button) then
		editor.set_current_mode(editor.modes.circ)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over circfill mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.circfill_mode_button) then
		editor.set_current_mode(editor.modes.circfill)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over oval mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.oval_mode_button) then
		editor.set_current_mode(editor.modes.oval)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
	end

	-- Check if mouse is over ovalfill mode button.
	if utils.mouse_box_bound_check_for_buttons(x, y, editor.ovalfill_mode_button) then
		editor.set_current_mode(editor.modes.ovalfill)
		editor.switch_current_toggle_mode()
		editor.exit_drawing_primitives()
		return
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
		editor.exit_drawing_primitives()
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

	-- Check if mouse is over current sprite
	-- and proceed to start primitive drawing if the process has not been started yet.
	if utils.mouse_box_bound_check(
		x,
		editor.current_sprite_x_start * g.screen.gamepixel.w,
		(editor.current_sprite_x_start + (8 * g.sprites.size_w)) * g.screen.gamepixel.w,
		y,
		editor.current_sprite_y_start * g.screen.gamepixel.h,
		(editor.current_sprite_y_start + (8 * g.sprites.size_h)) * g.screen.gamepixel.h
	) and editor.current_mode ~= editor.modes.point and not editor.drawing_primitives then
		local sprite_x = math.ceil(((x / g.screen.gamepixel.w) - editor.current_sprite_x_start) / g.sprites.size_w)
		local sprite_y = math.ceil(((y / g.screen.gamepixel.h) - editor.current_sprite_y_start) / g.sprites.size_h)
		editor.drawing_primitives = true
		editor.anchor_primitive = {
			x = sprite_x,
			y = sprite_y
		}
		return
	end

	-- If we click anywhere else, and we are in the process of drawing primitives,
	-- then commit the changes and exit primitive drawing mode.
	if editor.current_mode ~= editor.modes.point and editor.drawing_primitives then
		editor.current_sprite_data = nil
		editor.current_sprite_data = utils.experimental_deepcopy(editor.temp_sprite_data)
		s.set_sprite(editor.current_sprite, editor.current_sprite_data)
		editor.exit_drawing_primitives()
	end
end


function editor.handle_mouseholding(x, y, button)
	--[[
	handle_mouseholding is used only for handling drawing over current sprite.
	All other interactions with UI or other drawing modes are handled
	by other functions, namely handle_mousepresses
	and handle_mousepresses_point_drawing_mode_special_case.

	If user is in point drawing mode, then this function allows to draw
	continuously over the existing sprite. In that case, all changes
	are immediately commited into the current sprite data.

	If user is in primitive drawing mode, then if no button is pressed,
	it calculates data used to show preview of primitive to be drawn.
	In that case, no changes are immediately commited.

	Arguments
	---------
	x : number
		mouse position on x ax; this value is passed from love.mousepressed
	y : number
		mouse position on y ax; this value is passed from love.mousepressed
	button : number
		mouse button; 1 is left mouse button, 2 is right mouse button

	Returns
	-------
	nothing
	]]--

	if not button and editor.drawing_primitives then
		editor.primitive_args = nil
		local mouse_x = math.ceil(((x / g.screen.gamepixel.w) - editor.current_sprite_x_start) / g.sprites.size_w)
		local mouse_y = math.ceil(((y / g.screen.gamepixel.h) - editor.current_sprite_y_start) / g.sprites.size_h)
		editor.primitive_args = {
			editor.anchor_primitive.x,
			editor.anchor_primitive.y,
		}
		if editor.current_mode == editor.modes.line then
			table.insert(editor.primitive_args, mouse_x)
			table.insert(editor.primitive_args, mouse_y)
		elseif editor.current_mode == editor.modes.rect or editor.current_mode == editor.modes.rectfill then
			local w = utils.distance_between(
				editor.anchor_primitive.x,
				editor.anchor_primitive.y,
				mouse_x,
				editor.anchor_primitive.y
			)
			local h = utils.distance_between(
				editor.anchor_primitive.x,
				editor.anchor_primitive.y,
				editor.anchor_primitive.x,
				mouse_y
			)
			if mouse_x >= editor.anchor_primitive.x then
				table.insert(editor.primitive_args, w+1)
			else
				table.insert(editor.primitive_args, -w)
			end
			if mouse_y >= editor.anchor_primitive.y then
				table.insert(editor.primitive_args, h+1)
			else
				table.insert(editor.primitive_args, -h)
			end
		elseif editor.current_mode == editor.modes.circ or editor.current_mode == editor.modes.circfill then
			local r = utils.distance_between(
				editor.anchor_primitive.x,
				editor.anchor_primitive.y,
				mouse_x,
				mouse_y
			)
			table.insert(editor.primitive_args, r)
		elseif editor.current_mode == editor.modes.oval or editor.current_mode == editor.modes.ovalfill then
			local rx = utils.distance_between(
				editor.anchor_primitive.x,
				editor.anchor_primitive.y,
				mouse_x,
				editor.anchor_primitive.y
			)
			local ry = utils.distance_between(
				editor.anchor_primitive.x,
				editor.anchor_primitive.y,
				editor.anchor_primitive.x,
				mouse_y
			)
			table.insert(editor.primitive_args, rx)
			table.insert(editor.primitive_args, ry)
		end
	end

	-- This closure is used later to use within pcall to emulate
	-- behaviour similar to try-except
	local function replace_sprite_pixel(sprite_1_x, sprite_1_y)
		g.sprites.sprites[editor.current_sprite]["colors"][sprite_1_y][sprite_1_x] = editor.colors[editor.current_color][1]
	end

	if button and love.mouse.isDown(button) then
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


function editor.handle_mousepresses_point_drawing_mode_special_case(x, y, button)
	--[[
	This function helps with handling `point drawing mode` that is kind of
	special case.

	The primary work for `point drawing mode` is already being handled by
	handle_mouseholding, but it has to be handled by this function too,
	as without this, you could not draw things by simply clicking on current_sprite;
	instead, you would need to click and move mouse to introduce the change.

	All other interactions with UI or other drawing modes are handled
	by handle_mousepresses.

	Arguments
	---------
	x : number
		mouse position on x ax; this value is passed from love.mousepressed
	y : number
		mouse position on y ax; this value is passed from love.mousepressed
	button : number
		mouse button; 1 is left mouse button, 2 is right mouse button

	Returns
	-------
	nothing
	]]--

	if button ~= 1 then
		return
	end

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
