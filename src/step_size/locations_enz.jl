# Author: Sean Wu
# Last Updated: December 11, 2020

function insensor(xy::Array{Float64,1})::Bool
    x, y = xy
    withinx = abs(x) < SENSOR_HALF_WIDTH
    withiny = y < 0
    return withinx && withiny
end

function inwalls(x::Float64, y::Float64)::Bool
    withinx = SENSOR_HALF_WIDTH < abs(x) <= ESCAPE_X
    withiny = y < 0
    return withinx && withiny
end

function inenz(xy::Array{Float64,1})::Bool
    withinx = ENZYME_LEFT_X <= xy[1] <= ENZYME_RIGHT_X
    withiny = WALL_Y < xy[2] <= ENZYME_MAX_Y
    return withinx && withiny
end

function inwater(xy::Array{Float64,1})::Bool
    x, y = xy
    aboveEnzX = abs(x) <= ESCAPE_X
    aboveEnzY = ENZYME_MAX_Y < y <= ESCAPE_Y
    besideEnzX = ENZYME_RIGHT_X < abs(x) <= ESCAPE_X
    besideEnzY = WALL_Y < y <= ENZYME_MAX_Y
    return (aboveEnzX && aboveEnzY) || (besideEnzX && besideEnzY)
end

function inppd(xy::Array{Float64,1})::Bool
    return false
end

function sensorcases(x::Float64)::String
    return "sensor"
end

function wallcases(initxy::Array{Float64,1},
                   dx::Float64,
                   dy::Float64,
                   ending_step_size::Float64)::Tuple{Array{Int64,1},String}
    return approach_wall!(initxy, dx, dy, ending_step_size), "no collision"
end
