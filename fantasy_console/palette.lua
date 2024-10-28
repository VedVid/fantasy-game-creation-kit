local palette = {}


palette.black = {
    number=1,
    hex="#1E1E1E",
    rgb01={0.118, 0.118, 0.118, 1}
}

palette.black_bold = {
    number=2,
    hex="#7F7061",
    rgb01={0.498, 0.439, 0.38, 1}
}

palette.red = {
    number=3,
    hex="#BE0F17",
    rgb01={0.745, 0.059, 0.09, 1}
}

palette.red_bold = {
    number=4,
    hex="#F73028",
    rgb01={0.969, 0.188, 0.157, 1}
}

palette.green = {
    number=5,
    hex="#487548",
    rgb01={0.282, 0.459, 0.282, 1}
}

palette.green_bold = {
    number=6,
    hex="#80B56D",
    rgb01={0.502, 0.71, 0.427, 1}
}

palette.yellow = {
    number=7,
    hex="#CC881A",
    rgb01={0.8, 0.533, 0.102, 1}
}

palette.yellow_bold = {
    number=8,
    hex="#F7B125",
    rgb01={0.969, 0.694, 0.145, 1}
}

palette.blue = {
    number=9,
    hex="#004080",
    rgb01={0, 0.251, 0.502, 1}
}

palette.blue_bold = {
    number=10,
    hex="#3399FF",
    rgb01={0.2, 0.6, 1, 1}
}

palette.magenta = {
    number=11,
    hex="#A04B73",
    rgb01={0.627, 0.294, 0.451, 1}
}

palette.magenta_bold = {
    number=12,
    hex="#C77089",
    rgb01={0.78, 0.439, 0.537, 1}
}

palette.cyan = {
    number=13,
    hex="#377375",
    rgb01={0.216, 0.451, 0.459, 1}
}

palette.cyan_bold = {
    number=14,
    hex="#719586",
    rgb01={0.443, 0.584, 0.525, 1}
}

palette.white = {
    number=15,
    hex="#978771",
    rgb01={0.592, 0.529, 0.443, 1}
}

palette.white_bold = {
    number=16,
    hex="#E6D4A3",
    rgb01={0.902, 0.831, 0.639, 1}
}

palette.colors = {
    palette.black,
    palette.black_bold,
    palette.red,
    palette.red_bold,
    palette.green,
    palette.green_bold,
    palette.yellow,
    palette.yellow_bold,
    palette.blue,
    palette.blue_bold,
    palette.magenta,
    palette.magenta_bold,
    palette.cyan,
    palette.cyan_bold,
    palette.white,
    palette.white_bold
}


function palette.find_color_by_hex(hexc)
    --[[
    Method find_color_by_hex searches through palette.colors trying
    to find color that matches hex color passed as `hexc` argument.
    This functionality is used by API functions that read color
    values from the external files like `data/sprites.json`.
    Errors if no color matches passed hex code.

    Arguments
    ---------
    hexc : string
        Color in hexadecimal format.

    Returns
    -------
    palette.<color>
    ]]--

    for _, color in pairs(palette.colors) do
        if color.hex == hexc then
            return color
        end
    end
    error("Couldn't find correct color for hex value: " .. hexc)
end


return palette
