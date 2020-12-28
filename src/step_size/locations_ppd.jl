function spawnrandompoint(randFloatX::Float64=rand(), randFloatY::Float64=rand())::Array{Float64,1}
    newxy = copy(SPAWN_TOP_LEFT_XY)
    newxy[1] += randFloatX * SPAWN_X_RANGE
    newxy[2] -= randFloatY * SPAWN_Y_RANGE
    return newxy
end

function insensor(xy::Array{Float64,1})::Bool
    y = xy[2]
    return y <= PPD_MIN_Y
end

function inwalls(x::Float64, y::Float64)::Bool
    withinx = SENSOR_HALF_WIDTH < abs(x) <= ESCAPE_X
    withiny = PPD_MIN_Y < y < WALL_Y
    return withinx && withiny
end

function inppd(xy::Array{Float64,1})::Bool
    withinx = abs(xy[1]) <= SENSOR_HALF_WIDTH
    withiny = PPD_MIN_Y < xy[2] <= PPD_MAX_Y
    return withinx && withiny
end

function inwater(xy::Array{Float64,1})::Bool
    x, y = xy
    abovewallx = abs(x) <= ESCAPE_X
    abovewally = WALL_Y < y <= ESCAPE_Y
    inwellx = abs(x) <= SENSOR_HALF_WIDTH
    inwelly = PPD_MAX_Y < y <= WALL_Y
    return (abovewallx && abovewally) || (inwellx && inwelly)
end

function inenz(xy::Array{Float64,1})::Bool
    # No enzyme layer
    return false
end

function whereoutsidespawn(xy::Array{Float64,1})::String
    # No Enzyme Layer, only horizontal inteface between
    # Water and PPD Layer inside sensor well
    return "N"
end

function sensorcases(x::Array{Float64,1})::String
    # only one sensor
    return "sensor"
end

function wallcases(initxy::Array{Float64,1},
                   dx::Float64,
                   dy::Float64,
                   ending_step_size::Float64)
    return approach_wall!(initxy, dx, dy, ending_step_size), "no collision"
end
