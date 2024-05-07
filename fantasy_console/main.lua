require "_cart"
local canvas = require "canvas"


function love.load()
    canvas.get_player_screen_dimension()
    canvas.set_global_screen_variables(canvas.default_scale)
    canvas.set_window_size()
    Init()
end

function love.update()
    Update()
end

function love.draw()
    Draw()
end
