local utils = {}

function utils.distance_between(sx, sy, tx, ty)
    local dx = tx - sx
    local dy = ty - sy
    local distance = math.floor(math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)))
    return distance
end

return utils
