require "api"


local g = require "globals"
local palette = require "palette"
local utils = require "utils"


local editor = {}


-- Data related to the sound effects
editor.sound_effects_max = 10
editor.sounds_per_effect_max = 4


-- Data related to tabs that are used to switch between pages of sounds list.
editor.current_tab = 1
editor.current_effect = 1
editor.current_sound = 1


-- Data relevant to drawing UI
editor.effects_x_start = 30
editor.effects_y_start = 30
editor.row_heigh = 2 * g.screen.gamepixel.h
editor.column_x_effect_number = editor.effects_x_start
editor.column_width_effect_number = 3 * g.screen.gamepixel.w
editor.column_x_length = editor.column_x_effect_number + editor.column_width_effect_number + 1
editor.column_width_length = 6 * g.screen.gamepixel.w
editor.column_x_volume = editor.column_x_length + editor.column_width_length + 1
editor.column_width_volume = 6 * g.screen.gamepixel.w
editor.column_x_sounds = editor.column_x_volume + editor.column_width_volume + 1
editor.column_width_sounds = 6 * g.screen.gamepixel.w
editor.column_x_waveform = editor.column_x_sounds + editor.column_width_sounds + 1
editor.column_width_waveform = 8 * g.screen.gamepixel.w


function editor.draw_all_sound_effects()
    local y = editor.effects_y_start

    local sound_effect_border = {}

    for i=1, editor.sound_effects_max do
        -- Add the header
        if i == 1 then
            Write(editor.column_x_effect_number, y, "No.", WhiteBold)
            Write(editor.column_x_length, y, "Length", WhiteBold)
            Write(editor.column_x_volume, y, "Volume", WhiteBold)
            Write(editor.column_x_sounds, y, "Sounds", WhiteBold)
            Write(editor.column_x_waveform, y, "Waveform", WhiteBold)
        else
            Write(editor.column_x_effect_number, y, tostring(i), WhiteBold)
            Write(editor.column_x_length, y, "--- 100 ms +++", WhiteBold)
            Write(editor.column_x_volume, y, "- 3 +", WhiteBold)
            Write(editor.column_x_waveform, y, "< SIN >", WhiteBold)
        end
        y = y + editor.row_heigh
    end
end


return editor