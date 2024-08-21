local palette = require "palette"


local globals = {}

globals.min_dt = 1/30
globals.next_time = 0

globals.font_name = "Pixuf.ttf"
globals.font = nil

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

globals.colors = {}
globals.colors.default_fg_color = palette.white
globals.colors.default_bg_color = palette.black

globals.sprites_amount = 512
globals.sprites_path_test = "data/sprites_test.json"
globals.sprites_path = "fantasy_console/data/sprites.json"

return globals
