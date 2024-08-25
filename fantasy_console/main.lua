require "_cart"
local canvas = require "canvas"
--local data_sprites = require "data/sprites"
local g = require "globals"
local sprite = require "sprite"


local mode = nil

function love.load(args)
    mode = args[1] or "playing"
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
        error("sprites table in data/sprites.json is partially filled. Data corruption possible.")
    elseif #all_sprites > g.sprites_amount then
        error("sprites table in data/sprites.json holds too many sprites. Something wrong happened.")
    end
    g.next_time = love.timer.getTime()
    if mode == "playing" then
        Init()
    elseif mode == "sprites" then
        do end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "pageup" then
        canvas.scale_up()
    elseif key == "pagedown" then
        canvas.scale_down()
    end
    if mode == "playing" then
        Input()
    elseif mode == "sprites" then
        do end
    end
end

function love.update()
    g.next_time = g.next_time + g.min_dt
    if mode == "playing" then
        Update()
    elseif mode == "sprites" then
        do end
    end
end

function love.draw()
    canvas.set_background_color()
    if mode == "playing" then
        Draw()
    elseif mode == "sprites" then
        do end
    end
    local current_time = love.timer.getTime()
    if g.next_time <= current_time then
        g.next_time = current_time
        return
    end
    love.timer.sleep(g.next_time - current_time)
end
