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
    Write(txt, 1, 1, YellowBold)
    Write(txt2, 1, 1+8, BlackBold)
    Write(txt3, 1, 1+16, Pink)
    --Ppset(pix)
    local palette = require "palette"
    Pset(1, 1, BlueBold)
    Pset(2, 1, PinkBold)
    Ppset(pix)
    Ppset(pix2)
    Pset(29, 30, CyanBold)
    Pset(29, 34, Cyan)
    Rect(29, 30, 4, 4, GreenBold)
    Pset(34, 30, Cyan)
    Pset(34, 34, CyanBold)
    Rectfill(34, 30, 4, 4, BlueBold)
    Circ(60, 30, 8, GreenBold)
    Circfill(80, 30, 8, Green)
    Oval(60, 60, 20, 10, Blue)
    Oval(100, 30, 4, 10, White)
    Ovalfill(125, 30, 15, 6, YellowBold)
    Ovalfill(150, 30, 6, 15, Yellow)
    Ovalfill(175, 30, 10, 10, GreenBold)
    Line(10, 60, 20, 60, WhiteBold)
    Pset(10, 59, Red)
    Pset(20, 59, RedBold)
    Pset(10, 61, Cyan)
    Pset(20, 61, CyanBold)
    Rect(10, 62, 10, 2, BlueBold)
end
