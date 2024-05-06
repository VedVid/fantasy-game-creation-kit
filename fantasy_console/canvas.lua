local canvas = {}

canvas.scale_1920x1080 = {}
canvas.scale_1920x1080.px_w = 5
canvas.scale_1920x1080.px_h = 5
canvas.scale_1920x1080.w = 256 * 5
canvas.scale_1920x1080.h = 192 * 5

canvas.scale_1366x768 = {}
canvas.scale_1366x768.px_w = 3
canvas.scale_1366x768.px_h = 3
canvas.scale_1366x768.w = 256 * 3
canvas.scale_1366x768.h = 192 * 3

canvas.scale_2560x1440 = {}
canvas.scale_2560x1440.px_w = 6
canvas.scale_2560x1440.px_h = 6
canvas.scale_2560x1440.w = 256 * 6
canvas.scale_2560x1440.h = 192 * 6

canvas.scale_3840x2160 = {}
canvas.scale_3840x2160.px_w = 9
canvas.scale_3840x2160.px_h = 9
canvas.scale_3840x2160.w = 256 * 9
canvas.scale_3840x2160.h = 256 * 9

canvas.current_scale = nil


function canvas.get_player_screen_dimension()
    local _, _, flags = love.window.getMode()
    local _, screen_height = love.window.getDesktopDimensions(flags.displaye)
    if screen_height <= 768 then
        canvas.current_scale = canvas.scale_1366x768
    elseif screen_height <= 1080 then
        canvas.current_scale = canvas.scale_1920x1080
    elseif screen_height <= 1440 then
        canvas.current_scale = canvas.scale_2560x1440
    else
        canvas.current_scale = canvas.scale_3840x2160
    end
end


function canvas.set_window_size()
    love.window.setMode(canvas.current_scale.w, canvas.current_scale.h)
end


return canvas
