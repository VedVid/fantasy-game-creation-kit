require "_cart"
local canvas = require "canvas"
--local data_sprites = require "data/sprites"
local g = require "globals"
local sprite = require "sprite"
local sprite_editor = require "sprite_editor"


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
    g.sprites.sprites = sprite.get_all_sprites()
    if #g.sprites.sprites == 0 then
        sprite.initialize_blank_sprites()
    elseif #g.sprites.sprites < g.sprites.amount then
        error("sprites table in data/sprites.json is partially filled. Data corruption possible.")
    elseif #g.sprites.sprites > g.sprites.amount then
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
    end  -- More modes might come here
end

function love.mousepressed(x, y, button, istouch, presses)
    if mode == "sprites" then
        sprite_editor.handle_mousepresses(x, y, button)
    end
end

function love.update()
    g.next_time = g.next_time + g.min_dt
    if mode == "playing" then
        Update()
    elseif mode == "sprites" then
        sprite_editor.update_save_button()
    end
end

function love.draw()
    canvas.set_background_color()
    if mode == "playing" then
        Draw()
    elseif mode == "sprites" then
        love.graphics.clear(g.colors.default_fg_color.rgb01)
        sprite_editor.draw_spritesheet_buttons()
        sprite_editor.draw_all_sprites()
        sprite_editor.draw_colors()
        sprite_editor.draw_save_button()
        sprite_editor.draw_current_sprite()
    end
    local current_time = love.timer.getTime()
    if g.next_time <= current_time then
        g.next_time = current_time
        return
    end
    love.timer.sleep(g.next_time - current_time)
end
