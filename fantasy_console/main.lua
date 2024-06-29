require "_cart"
local canvas = require "canvas"
--local data_sprites = require "data/sprites"
local g = require "globals"
local sprite = require "sprite"


function love.load()
    canvas.get_player_screen_dimension()
    canvas.set_global_screen_variables(canvas.default_scale)
    canvas.set_window_size()
    canvas.set_background_color()
    canvas.set_font()
    canvas.set_line_style()
    canvas.set_line_width()
    local all_sprites = sprite.get_all_sprites()
    if #all_sprites == 0 then
        sprite.initialize_blank_sprites()
    elseif #all_sprites < g.sprites_amount then
        error("sprites table in _cartdata.lua is partially filled. Data corruption possible.")
    elseif #all_sprites > g.sprites_amount then
        error("sprites table in _cartdata.lua holds too many sprites. Something wrong happened.")
    end
    g.next_time = love.timer.getTime()
    -- !@!!!!!!
    local ssss = sprite.get_sprite(1)
    local colors = ssss["colors"]
    for _, color in pairs(colors) do
        for _, v in pairs(color) do
            --print(row)
            print()
            for k, d in pairs(v) do
                if k == "hex" then
                    print(d)
                end
            end
        end
        --print(color)
    end
    -- !!!!!!!
    Init()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "pageup" then
        canvas.scale_up()
    elseif key == "pagedown" then
        canvas.scale_down()
    end
    Input()
end

function love.update()
    g.next_time = g.next_time + g.min_dt
    Update()
end

function love.draw()
    canvas.set_background_color()
    Draw()
    local current_time = love.timer.getTime()
    if g.next_time <= current_time then
        g.next_time = current_time
        return
    end
    love.timer.sleep(g.next_time - current_time)
end
