require "api"

local g = require "globals"


local editor = {}


function editor.draw_all_sprites(tab)
	local cols = 30
	local rows = 7
	--local tabs = 3

	local start = 1
	if tab > 1 then
		start = cols * rows * tab
	end

	local x = 4
	local y = 4

--	Spr(1, x, y)
	for i=start, start+(cols*rows) do
		Spr(i, x, y)
		x = x + g.sprites_size_h
		if x > g.screen.size.gamepixels.w then
			x = 4
			y = y + 8
		end
	end
end


return editor
