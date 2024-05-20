require "api"

function Init()
    txt = "Hello from Love2D!"
    num = 1
    txt2 = "Hello from Fantasy Console! x" .. num
    txt3 = Sub("Česká", 2, 5) -- eská expected
    local gamepixel = require "gamepixel"
    local palette = require "palette"
    pix = gamepixel.new_gamepixel(1, 2, palette.red_bold)
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
    Pset(1, 1, palette.blue_bold)
    Pset(2, 1, palette.magenta_bold)
    Ppset(pix)
    Ppset(pix2)
    Pset(29, 30, palette.cyan_bold)
    Pset(29, 34, palette.cyan)
    Rect(29, 30, 4, 4, palette.green_bold)
    Pset(34, 30, palette.cyan)
    Pset(34, 34, palette.cyan_bold)
    Rectfill(34, 30, 4, 4, palette.blue_bold)
end
