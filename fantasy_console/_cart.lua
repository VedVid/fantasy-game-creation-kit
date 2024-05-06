require "api"

function Init()
    txt = "Hello from Love2D!"
    txt2 = ""
end

function Update()
    txt2 = "Hello from Fantasy Console!"
end

function Draw()
    Write(txt, 10, 10)
    Write(txt2, 10, 50)
end
