--[[
This file defines all elements of API that user can use
in their game.
All functions are provided as global functions to give
the feeling of using some kind of console – I wanted to avoid
requiring user to write repeatedly module name over and over.
]]--


function Write(s, x, y)
    --[[
    Method Write uses the Love2D's print function under the
    hood, but it does not expose all of its arguments to the
    user. 
    Rotation, scaling, and offset are set to the Love2D's
    defaults.

    Currently coords are passed 1:1 because pixel scaling
    is not implemented yet.

    Arguments
    ---------
    s : string
        Text to be printed.
    x : number
        Position of text beginning at the x axis.
    y : number
        Position of text beginning at the y axis.
    
    Returns
    -------
    nothing
    ]]--

    love.graphics.print(s, x, y, 0, 1, 1, 0, 0)
end
