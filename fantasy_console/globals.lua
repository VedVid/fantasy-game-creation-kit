local palette = require "palette"


local globals = {}


-- FPS-related variables
globals.min_dt = 1/30
globals.next_time = 0

-- Font
globals.font_name = "Pixuf.ttf"
globals.font = nil

-- Screen-related variables
globals.screen = {}
globals.screen.gamepixel = {}
globals.screen.gamepixel.w = 5
globals.screen.gamepixel.h = 5
globals.screen.font_size = 8*5
globals.screen.size = {}
globals.screen.size.gamepixels = {}
globals.screen.size.gamepixels.w = 256
globals.screen.size.gamepixels.h = 192
globals.screen.size.pixels = {}
globals.screen.size.pixels.w = globals.screen.size.gamepixels.w * globals.screen.gamepixel.w
globals.screen.size.pixels.h = globals.screen.size.gamepixels.h * globals.screen.gamepixel.h

-- Variables related to coloring
globals.colors = {}
globals.colors.default_fg_color = palette.white
globals.colors.default_bg_color = palette.black
globals.colors.default_button_border_color = palette.cyan
globals.colors.default_button_border_color_active = palette.magenta_bold
globals.colors.default_button_background_color = palette.black_bold
globals.colors.default_button_background_color_active = palette.white_bold

-- Sprites-related variables
globals.sprites = {}
globals.sprites.sprites = nil
globals.sprites.size_w = 8
globals.sprites.size_h = 8
globals.sprites.amount = 512
globals.sprites.path_test = "data/sprites_test.json"
globals.sprites.path = "fantasy_console/data/sprites.json"


return globals
