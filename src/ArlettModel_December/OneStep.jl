# Author: Sean Wu
# Last Updated: November 12, 2020

#include("BoundaryCheck.jl")



function oneStep(initialXY)
    theta = 2 * pi * rand(Float64) - pi  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)

    if inSafeBounds(initialXY)   # fast computation
        flowBias = flow(initialXY)
        # IMPORTANT: updating arrays always faster than initializing new array
        initialXY[1] += waterStepSize * dx + flowBias
        initialXY[2] += waterStepSize * dy
        return initialXY, "no collision"
    else                            # more computation needed
        return boundaryCheck(initialXY, dx, dy)
    end
end

function inSafeBounds(xy)
    return abs(xy[1]) < safeMaxX && safeMinY < xy[2] && xy[2] < safeMaxY
end
