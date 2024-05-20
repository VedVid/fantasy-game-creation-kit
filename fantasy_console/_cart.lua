require "api"

function Init()
    txt = "Hello from Love2D!"
    num = 1
    txt2 = "Hello from Fantasy Console! x" .. num
    txt3 = Sub("Česká", 2, 5) -- eská expected
    local gamepixel = require "gamepixel"
    local palette = require "palette"
    pix = gamepixel.new_gamepixel(1, 2, palette.green)
    pix2 = gamepixel.new_gamepixel(2, 2, palette.green_bold)
end

function Update()
    num = num + 1
    txt2 = "Hello from Fantasy Console! x" .. num
end

function Draw()
    Write(txt, 1, 1)
    Write(txt2, 1, 1+8)
    Write(txt3, 1, 1+16)
    --Ppset(pix)
    local palette = require "palette"
    Pset(1, 1, BlueBold())
    Pset(2, 1, PinkBold())
    Ppset(pix)
    Ppset(pix2)
    Pset(29, 30, CyanBold())
    Pset(29, 34, Cyan())
    Rect(29, 30, 4, 4, GreenBold())
    Pset(34, 30, Cyan())
    Pset(34, 34, CyanBold())
    Rectfill(34, 30, 4, 4, BlueBold())
end
