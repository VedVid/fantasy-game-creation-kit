local globals = {}

globals.screen = {}
globals.screen.gamepixel = {}
globals.screen.gamepixel.w = 5
globals.screen.gamepixel.h = 5
globals.screen.size = {}
globals.screen.size.gamepixels = {}
globals.screen.size.gamepixels.w = 256
globals.screen.size.gamepixels.h = 192
globals.screen.size.pixels = {}
globals.screen.size.pixels.w = globals.screen.size.gamepixels.w * globals.screen.gamepixel.w
globals.screen.size.pixels.h = globals.screen.size.gamepixels.h * globals.screen.gamepixel.h

return globals
