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

ProFi = require 'ProFi'
function Draw()
    ProFi:start()
    Spr(1, 0, 0)
    Pset(0, 1, Blue)
    Spr(1, 8, 8)
    Pset(0, 2, Blue)
    Spr(1, 16, 16)
    Pset(0, 3, Blue)
    ProFi:stop()
    ProFi:writeReport( 'MyProfilingReport.txt' )
end
