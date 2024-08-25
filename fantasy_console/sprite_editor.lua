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

	local x = g.sprites.size_w
	local y = 192 - ((rows + 1) * g.sprites.size_h)

	for i=start, cols*rows do
		Spr(i, x, y)
		x = x + g.sprites.size_w
		if x >= g.screen.size.gamepixels.w - (1.5 * g.sprites.size_w) then
			x = g.sprites.size_w
			y = y + g.sprites.size_h
		end
	end
end


return editor
