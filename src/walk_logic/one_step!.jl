# Author: Sean Wu
# Last Updated: November 12, 2020

"""
    one_step!

Quickly compute the next xy coordinate or anticipate a collision/border cross
by calling for more computation.
"""
function one_step!(initxy::Array{Float64,1})
    theta = 2 * pi * rand(Float64) - pi  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)

    if insafebounds(initxy)   # fast computation
        flowBias = flow_arlett(initxy)
        # IMPORTANT: updating arrays always faster than initizing new array
        initxy[1] += WATER_STEP_SIZE * dx + flowBias
        initxy[2] += WATER_STEP_SIZE * dy
        return initxy, "no collision"
    else                            # more computation needed
        return boundary_check(initxy, dx, dy)
    end
end

"In water and away from borders and collisions"
function insafebounds(xy::Array{Float64,1})::Bool
    return abs(xy[1]) < SAFE_MAX_X && SAFE_MIN_Y < xy[2] < SAFE_MAX_Y
end

"Far ends of the simulation space to end a runaway walk"
function inescapebounds(x::Float64, y::Float64)::Bool
    withinx = -1*ESCAPE_X <= x <= ESCAPE_X
    withiny = -1 <= y <= ESCAPE_Y
    return withinx && withiny
end
