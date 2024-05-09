require "_cart"
local canvas = require "canvas"
local g = require "globals"


function love.load()
    canvas.get_player_screen_dimension()
    canvas.set_global_screen_variables(canvas.default_scale)
    canvas.set_window_size()
    g.next_time = love.timer.getTime()
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
    g.next_time = g.next_time + g.min_dt
    Update()
end

function love.draw()
    Draw()
    local current_time = love.timer.getTime()
    if g.next_time <= current_time then
        g.next_time = current_time
        return
    end
    love.timer.sleep(g.next_time - current_time)
end
