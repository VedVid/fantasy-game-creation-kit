require "api"


function Init()
    do end
end


function Input()
    do end
end


function Update()
    do end
end


function Draw()
    Write(85, 5, "Write(x, y, text, color)", Green)
    Write(40, 20, "Pset(x, y, color)")
    Pset(40, 30, Blue)
    Pset(42, 30, Cyan)
    Pset(44, 30, Green)
    Pset(46, 30, Pink)
    Pset(48, 30, Red)
    Pset(50, 30, Yellow)
    Write(130, 20, "Line(x1, y1, x2, y2, color)")
    Line(130, 30, 151, 40, BlueBold)
    Line(130, 40, 151, 30, CyanBold)
    Line(130, 35, 151, 35, GreenBold)
    Line(140, 30, 141, 40, PinkBold)
    Line(141, 30, 140, 40, RedBold)
    Line(130, 35, 151, 35, GreenBold)
    Write(40, 50, "Rect(x, y, w, h, color)")
    Rect(40, 60, 10, 10, Blue)
    Rect(51, 60, 8, 8, Cyan)
    Rect(60, 60, 6, 6, Green)
    Rect(67, 60, 5, 5, Pink)
    Rect(73, 60, 4, 4, Red)
    Rect(78, 60, 3, 3, Yellow)
    Write(130, 50, "Rectfill(x, y, w, h, color)")
    Rectfill(130, 60, 10, 10, BlueBold)
    Rectfill(141, 60, 8, 8, CyanBold)
    Rectfill(150, 60, 6, 6, GreenBold)
    Rectfill(157, 60, 5, 5, PinkBold)
    Rectfill(163, 60, 4, 4, RedBold)
    Rectfill(168, 60, 3, 3, YellowBold)
    Write(40, 79, "Circ(x, y, r, color)")
    Circ(45, 95, 6, Blue)
    Circ(58, 95, 5, Cyan)
    Circ(69, 95, 4, Green)
    Circ(78, 95, 3, Pink)
    Circ(85, 95, 2, Red)
    Circ(90, 95, 1, Yellow)
    Write(130, 79, "Circfill(x, y, r, color)")
    Circfill(135, 95, 6, BlueBold)
    Circfill(148, 95, 5, CyanBold)
    Circfill(159, 95, 4, GreenBold)
    Circfill(168, 95, 3, PinkBold)
    Circfill(175, 95, 2, RedBold)
    Circfill(180, 95, 1, YellowBold)
    Write(40, 111, "Oval(x, y, rx, ry, color)")
    Oval(45, 125, 6, 4, Blue)
    Oval(58, 125, 5, 4, Cyan)
    Oval(70, 125, 5, 3, Green)
    Oval(81, 125, 4, 3, Pink)
    Oval(90, 125, 3, 2, Red)
    Oval(98, 125, 3, 1, Yellow)
    Write(130, 111, "Ovalfill(x, y, rx, ry, color)")
    Ovalfill(135, 125, 6, 4, Blue)
    Ovalfill(148, 125, 5, 4, Cyan)
    Ovalfill(160, 125, 5, 3, Green)
    Ovalfill(171, 125, 4, 3, Pink)
    Ovalfill(180, 125, 3, 2, Red)
    Ovalfill(188, 125, 3, 1, Yellow)
    Write(80, 140, "Spr(x, y, sprite_number)")
    Spr(100, 150, 1)
    Spr(108, 150, 2)
    Spr(116, 150, 1)
    Spr(124, 150, 2)
    Spr(132, 150, 1)
    Spr(140, 150, 2)
    Spr(100, 158, 31)
    Spr(108, 158, 32)
    Spr(116, 158, 31)
    Spr(124, 158, 32)
    Spr(132, 158, 31)
    Spr(140, 158, 32)
    Spr(100, 166, 3)
    Spr(108, 166, 4)
    Spr(116, 166, 5)
    Spr(124, 166, 6)
    Spr(132, 166, 3)
    Spr(140, 166, 4)
    Spr(100, 174, 33)
    Spr(108, 174, 34)
    Spr(116, 174, 35)
    Spr(124, 174, 36)
    Spr(132, 174, 33)
    Spr(140, 174, 34)
end
