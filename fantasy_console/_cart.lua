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
    Pset(10, 10, Blue)
    Pset(20, 10, BlueBold)
    Line(10, 12, 20, 12, Green)
    Rect(10, 14, 11, 5, Yellow)
    Rectfill(10, 20, 11, 5, YellowBold)
    Circ(15, 31, 5, White)
    Circfill(15, 43, 5, WhiteBold)
    Oval(15, 53, 5, 3, Red)
end
