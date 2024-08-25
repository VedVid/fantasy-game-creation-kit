require "api"

local g = require "globals"


local editor = {}

editor.current_tab = 1

function editor.set_current_tab(num)
	editor.current_tab = num
end

function editor.draw_all_sprites()
	local cols = 30
	local rows = 6
	local tab = editor.current_tab

	local start = 1
	if tab > 1 then
		start = cols * rows * (tab - 1)
	end

	local x = g.sprites.size_w
	local y = 192 - ((rows + 1) * g.sprites.size_h)

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


return editor
