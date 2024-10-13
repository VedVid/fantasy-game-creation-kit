local agc = require "api_geometry_calculations"
local g = require "globals"
local luaunit = require "luaunit"


--[[ Start of TestGeometryCalculations ]]

TestGeometryCalculations = {}


function TestGeometryCalculations.setUp()
    g.screen.gamepixel.w = 5
    g.screen.gamepixel.h = 5
end


-- Start of test_pset

function TestGeometryCalculations.test_pset__should_return_correct_coords__when_passed_correct_arguments()
    local expected_result = {{x = 20, y = 25}}

    local given_result = agc.pset(4, 5)

    luaunit.assertEquals(given_result, expected_result)
end


-- Start of test_line

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


-- Start of test_rect

function TestGeometryCalculations.test_rect__should_return_correct_anchor_point_and_dimensions__when_calculating_square()
    local expected_result = {
        lx = 27.5,
        ly = 27.5,
        lw = 20,
        lh = 20
    }

    local given_result = agc.rect(5, 5, 5, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rect__should_return_correct_anchor_point_and_dimensions__when_calculating_long_rect()
    local expected_result = {
        lx = 52.5,
        ly = 52.5,
        lw = 95,
        lh = 20
    }

    local given_result = agc.rect(10, 10, 20, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rect__should_return_correct_anchor_point_and_dimensions__when_calculating_high_rect()
    local expected_result = {
        lx = 7.5,
        ly = 17.5,
        lw = 20,
        lh = 70
    }

    local given_result = agc.rect(1, 3, 5, 15)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rect__should_return_correct_anchor_point_and_dimensions__when_calculating_tinies_possible_rect()
    local expected_result = {
        lx = 27.5,
        ly = 27.5,
        lw = 0,
        lh = 0
    }

    print("If API function is called with `1` for `w` and `h` parameters,")
    print("it will not print rectangle at all. It is expected tradeoff.")

    local given_result = agc.rect(5, 5, 1, 1)

    luaunit.assertEquals(given_result, expected_result)
end


-- Start of test_rectfill

function TestGeometryCalculations.test_rectfill__should_return_correct_anchor_point_and_dimensions__when_calculating_square()
    local expected_result = {
        lx = 25,
        ly = 25,
        lw = 25,
        lh = 25
    }

    local given_result = agc.rectfill(5, 5, 5, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rectfill__should_return_correct_anchor_point_and_dimensions__when_calculating_long_rect()
    local expected_result = {
        lx = 50,
        ly = 50,
        lw = 100,
        lh = 25
    }

    local given_result = agc.rectfill(10, 10, 20, 5)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rectfill__should_return_correct_anchor_point_and_dimensions__when_calculating_high_rect()
    local expected_result = {
        lx = 5,
        ly = 15,
        lw = 25,
        lh = 75
    }

    local given_result = agc.rectfill(1, 3, 5, 15)

    luaunit.assertEquals(given_result, expected_result)
end


function TestGeometryCalculations.test_rectfill__should_return_correct_anchor_point_and_dimensions__when_calculating_tinies_possible_rect()
    local expected_result = {
        lx = 25,
        ly = 25,
        lw = 5,
        lh = 5
    }

    print("Yes, `rectfill` behaviour is a tiny bit inconsistent with")
    print("`rect` behaviour")

    local given_result = agc.rectfill(5, 5, 1, 1)

    luaunit.assertEquals(given_result, expected_result)
end


--[[ End of TestGeometryCalculations ]]


os.exit(luaunit.LuaUnit.run())
