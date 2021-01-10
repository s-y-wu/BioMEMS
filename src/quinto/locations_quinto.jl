"Parylene walls in between sensors"
function inwalls(x::Float64, y::Float64)::Bool
    withinx = !inspawnsensorx(x) && !insecondsensorx(x) && !inthirdsensorx(x) && !infourthsensorx(x)
    withiny = y <= WALL_Y
    return withinx && withiny
end

"Above the center/spawn sensor"
function inspawnsensorx(x::Float64)::Bool
    return SENSOR_SPAWN_LEFT_X < x < SENSOR_WIDTH
