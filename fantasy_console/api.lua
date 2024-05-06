--[[
This file defines all elements of API that user can use
in their game.
All functions are provided as global functions to give
the feeling of using some kind of console – I wanted to avoid
requiring user to write repeatedly module name over and over.
]]--


local usub = require "stringEx"
local utf8 = require "utf8"


function Write(s, x, y)
    --[[
    Function Write uses the Love2D's print function under the
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


function Join(ss, delimiter)
    --[[
    Function Join joins multiple strings into single string.
    It is provided to make joining larger amount of strings into
    single string easier than by using `..` operator.

    Arguments
    ---------
    ss : array of strings
        Single table with all strings to be joined, e.g.
        {"text1", "text2"}
    delimiter : string = ""
        Optional argument. It specifies what symbol or text will
        be added between strings joined. Defaults to empty string.
    
    Returns
    -------
    string
    ]]--

    if not delimiter then
        delimiter = ""
    end
    local s = table.concat(ss, delimiter)
    return s
end


function Split(s, delimiter)
    --[[
    Function Split takes single string and delimiter as arguments,
    and tries to split the string on delimiter.
    If delimiter is not provided, it defaults to single space.
    If delimiter is set to empty string, this function returns the
    string passed without changes.

    Arguments
    ---------
    s : string
        Text to be split.
    delimiter : string = " "
        Delimiter used to split the string.
    
    Returns
    -------
    {strings}
    ]]--

    if delimiter == "" then
        return {s}
    end
    if not delimiter then
        delimiter = " "
    end

    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


function Sub(s, i, j)
    --[[
    Function Sub uses a third-party implementation of "usub" string
    method, provided by stringEx library by losttoken.

    Please see license at the top of stringEx.lua file.

    https://github.com/losttoken/lua-utf8-string
    accessed 20240506
    ]]--
    local result = string.usub(s, i, j)
    return result
end
