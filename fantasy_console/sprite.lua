--local data_sprites = require "data/sprites"
local json = require "json"
local g = require "globals"


local sprite = {}


sprite.default_color = g.colors.default_bg_color


--function sprite.set_pixel_color(sprite_no, pix_x, pix_y, color)
--  -- tables are passed as reference, so it should update, not?
--  local spr = sprite.get_sprite_from_cartdata(sprite_no)
--  spr.colors[pix_x][pix_y] = color
--end


function sprite.get_sprite(num)
    --[[
    Method get_sprite returns sprite from the sprites.json.

    Arguments
    ---------
    num : number
        The number indicating the location of the sprite that
        we want to return in order from the beginning
        of the sprites.json file.

    Returns
    -------
    sprite
    ]]--

    if num <= 0 then
        error("Invalid sprite number: " .. num .. " is smaller than 1.")
    elseif num > g.sprites.amount then
        error("Invalid sprite number: " .. num .. " is larger than total number of sprites (" .. g.sprites.amount .. ")")
    end

    return g.sprites.sprites[num]
end


function sprite.set_sprite(num, data)
    if num <= 0 then
        error("Invalid sprite number: " .. num .. " is smaller than 1.")
    elseif num > g.sprites.amount then
        error("Invalid sprite number: " .. num .. " is larger than total number of sprites (" .. g.sprites.amount .. ")")
    end

    -- Please note that this function creates new file on every call.
    -- It would be wiser to update in-memory sprites only, and to save the
    -- modified data to disk only later, e.g. when closing the app, or
    -- when hitting the "Save button".
    g.sprites.sprites[num]["colors"] = data
    local json_sprites_table = json.encode(g.sprites.sprites)
    -- !! DANGEROUS – it'll remove all data in sprites.json!
    local f = assert(io.open(g.sprites.path, "w+"))
    io.output(f)
    io.write(json_sprites_table)
    io.close(f)
end


function sprite.get_all_sprites()
    --[[
    Method get_all_sprites decodes (using json library by rxi)
    sprites.json file and returns it.

    Arguments
    ---------
    none

    Returns
    -------
    table of sprites
    ]]--

    local f = assert(io.open(g.sprites.path, "r"))
    local t = f:read("*all")
    io.close(f)
    local lua_sprite_table = json.decode(t)
    return lua_sprite_table
end


function sprite.new_blank_sprite()
    --[[
    Method new_blank_sprite creates blank sprite – ie, 8x8 sprite
    with all pixels in sprite's default_color (which equals to
    default_bg_color).
    It is used by sprite.initialize_blank_sprites when json file
    with sprites is created.

    Arguments
    ---------
    none

    Returns
    -------
    sprite
    ]]--

    local new_sprite = {}
    new_sprite.colors = {}
    for y = 1, 8 do
        local tmp_colors = {}
        for x = 1, 8 do
            table.insert(tmp_colors, sprite.default_color)
        end
        table.insert(new_sprite.colors, tmp_colors)
    end
    return new_sprite
end


function sprite.initialize_blank_sprites()
    --[[
    Method initialize_blank_sprites, using new_blank_sprite
    method, a table that consists of amount specified in sprites.amount
    global variable of blank sprites, when necessary
    (so, when colors.json does not exist and needs to be created).

    Arguments
    ---------
    none

    Returns
    -------
    nothing
    ]]--

    local tmp_table = {}
    for i = 1, g.sprites.amount do
        local spr = sprite.new_blank_sprite()
        table.insert(tmp_table, spr)
    end
    local json_sprite_table = json.encode(tmp_table)
    -- !! DANGEROUS – it'll remove all data in sprites.json!
    local f = assert(io.open(g.sprites.path, "w+"))
    io.output(f)
    io.write(json_sprite_table)
    io.close(f)
end


function sprite.return_sprite_colors(spr, returned_values, add_print)
    --[[
    Method return_sprite_colors returns hex value, rgb table, or raw json data
    of every pixel in specific sprite. Used only for debugging purposes.
    Optionally, printing hex values to console might be enabled.

    Arguments
    ---------
    num : number
        The number indicating the location of the sprite that
        we want to return in order from the beginning
        of the sprites.json file.

    returned_values : string
        "hex": table of hex values will be returned
        "rgb01": table of rgb01 tables will be returned
        "palette": full palette data, including color number, rgb01, and hex code
        default if nil: "hex"

    add_print : boolean
        If true value passed, then every hex value will be printed
        to the console.

    Returns
    -------
    table of hex values or table of rgb tables
    ]]--

    if not returned_values then
        returned_values = "hex"
    end

    if returned_values ~= "hex" and returned_values ~= "rgb01" and returned_values ~= "palette" then
        error("Incorrect value passed to `returned_values` parameter")
    end

    local colors = spr["colors"]

    if returned_values == "palette" then
        return colors
    end

    local values_to_return = {}

    for _, color in pairs(colors) do
        for _, v in pairs(color) do
            -- row
            for k, d in pairs(v) do
                if returned_values == "hex" then
                    if k == "hex" then
                        if add_print then
                            print(d)
                        end
                        table.insert(values_to_return, d)
                    end
                elseif returned_values == "rgb01" then
                    if k == "rgb01" then
                        if add_print then
                            print("r:" .. d[1] .. " g:" .. d[2] .. " b:" .. d[3] .. " a:" .. d[4])
                        end
                        table.insert(values_to_return, d)
                    end
                end
            end
        end
    	--print(color)
    end
    return values_to_return
end


return sprite
