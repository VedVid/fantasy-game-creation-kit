require "_cart"
local canvas = require "canvas"


function love.load()
    canvas.get_player_screen_dimension()
    canvas.set_global_screen_variables(canvas.default_scale)
    canvas.set_window_size()
    Init()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "pageup" then
        canvas.scale_up()
    elseif key == "pagedown" then
        canvas.scale_down()
    end
end

function love.update()
    Update()
end

function love.draw()
    Draw()
end
