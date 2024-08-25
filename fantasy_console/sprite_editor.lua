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

	for i=start, start+(cols*rows) do
		Spr(i, x, y)
		x = x + g.sprites.size_w
		if x >= g.screen.size.gamepixels.w - 4 then
			print(x)
			x = 4
			y = y + g.sprites.size_h
		end
	end
end


return editor
