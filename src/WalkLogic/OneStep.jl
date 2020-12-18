# Author: Sean Wu
# Last Updated: November 12, 2020

#include("BoundaryCheck.jl")

function onestep!(initxy::Array{Float64,1})::Tuple{Array{Float64,1},String}
    theta = 2 * pi * rand(Float64) - pi  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)

    if insafebounds(initxy)   # fast computation
        flowBias = flow(initxy)
        # IMPORTANT: updating arrays always faster than initizing new array
        initxy[1] += WATER_STEP_SIZE * dx + flowBias
        initxy[2] += WATER_STEP_SIZE * dy
        return initxy, "no collision"
    else                            # more computation needed
        return boundarycheck(initxy, dx, dy)
    end
end

function insafebounds(xy::Array{Float64,1})::Bool
    return abs(xy[1]) < SAFE_MAX_X && SAFE_MIN_Y < xy[2] < SAFE_MAX_Y
end

function inescapebounds(x::Float64, y::Float64)::Bool
    withinx = -1*ESCAPE_X <= x <= ESCAPE_X
    withiny = -1 <= y <= ESCAPE_Y
    return withinx && withiny
end
