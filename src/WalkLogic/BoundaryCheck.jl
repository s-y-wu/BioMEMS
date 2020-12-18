# Author: Sean Wu
# Last Updated: November 12, 2020

# using Documenter
using Random

"required imports for unit testing"
# sensorCases from locationbools or enz_locations
#include("CalcProposed.jl")
#include("Collision.jl")

"""
    boundarycheck

Confirm the next coordinates after initxy with unit displacement vectors
dx, dy. Resolve collisions with escape boundaries, sensors, and walls.

# Examples
```ju
"""
function boundarycheck(initxy, dx, dy)
    proposedxy, endingLayer = calculateproposedpoint(initxy, dx, dy)
    initx, inity = initxy
    propx, propy = proposedxy
    endingStepSize = STEP_SIZE_DICT[ endingLayer ]

    if inWalls(propx, propy)
        return sensewall!(initxy, dx, dy, endingStepSize), "no collision"
    elseif !inescapebounds(propx, propy)
        return undef, "escape"
    elseif inSensor(proposedxy)
        return undef, sensorcases(initx)
    else
        return proposedxy, "no collision"
    end
end

# when we do the top enzyme case
# function wallCases(initxy)
#     initx, inity = initxy
#     if inity <= WALL_Y
#         return "side wall"
#     elseif inity > WALL_Y
#         if inCenterWallsx(initx)
#             return "top wall"
#         elseif inInnerWallsx(initx)
#             return "top wall"
#         elseif inOuterWallsx(initx)
#             return "top wall"
#         end
#     end
#
#     if rand(Float64) > 0.5
#         return "sidewall"
#     else
#         return "top wall"
# end
