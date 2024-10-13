local agc = require "api_geometry_calculations"
local g = require "globals"
local luaunit = require "luaunit"


--[[ Start of TestGeometryCalculations ]]

TestGeometryCalculations = {}


function TestGeometryCalculations.setUp()
    g.screen.gamepixel.w = 5
    g.screen.gamepixel.h = 5
end


function TestGeometryCalculations.test_pset__should_return_correct_coords__when_passed_correct_arguments()
    local expected_result = {{x = 20, y = 25}}

    local given_result = agc.pset(4, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_line__should_return_correct_coords__when_calculating_horizontal_line()
    local expected_result = {
        {x = 25, y = 25},
        {x = 30, y = 25},
        {x = 35, y = 25},
        {x = 40, y = 25},
        {x = 45, y = 25},
        {x = 50, y = 25}
    }

    local given_result = agc.line(5, 5, 10, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_line__should_return_correct_coords__when_calculating_vertical_line()
    local expected_result = {
        {x = 25, y = 25},
        {x = 25, y = 30},
        {x = 25, y = 35},
        {x = 25, y = 40},
        {x = 25, y = 45},
        {x = 25, y = 50}
    }

    local given_result = agc.line(5, 5, 5, 10)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_line__should_return_correct_coords__when_calculating_diagonal_line()
    local expected_result = {
        {x = 25, y = 25},
        {x = 30, y = 30},
        {x = 35, y = 35},
        {x = 40, y = 40},
        {x = 45, y = 45},
        {x = 50, y = 50}
    }

    local given_result = agc.line(5, 5, 10, 10)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_line__should_return_correct_coords__when_calculating_skewed_line()
    local expected_result = {
        {x = 25, y = 25},
        {x = 30, y = 30},
        {x = 30, y = 35},
        {x = 35, y = 40},
        {x = 40, y = 45},
        {x = 45, y = 50},
        {x = 45, y = 55},
        {x = 50, y = 60}
    }

    local given_result = agc.line(5, 5, 10, 12)

    luaunit.assertEquals(given_result, expected_result)
end


--[[ End of TestGeometryCalculations ]]


os.exit(luaunit.LuaUnit.run())
