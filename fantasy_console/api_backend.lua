local g = require "globals"


-- shortcut for `api_backend`
local ab = {}


----------------------
---------- GEOMETRY --
----------------------


function ab.pset(x, y)

    local coords = {
        {
            x = math.floor(x * g.screen.gamepixel.w),
            y = math.floor(y * g.screen.gamepixel.h)
        }
    }

    return coords
end


return ab