require "api"

function Init()
    txt = "Hello from Love2D!"
    num = 1
    txt2 = "Hello from Fantasy Console! x" .. num
end

function Update()
    num = num + 1
    txt2 = "Hello from Fantasy Console! x" .. num
end

function Draw()
    Write(txt, 10, 10)
    Write(txt2, 10, 50)
end
