# Author: Sean Wu
# Last Updated: November 12, 2020

using Documenter
using Random

"required imports for unit testing"
#include("CalcProposed.jl")
#include("Collision.jl")

"""
    boundaryCheck

Confirm the next coordinates after initialXY with unit displacement vectors
dx, dy. Resolve collisions with escape boundaries, sensors, and walls.

# Examples
```ju
"""
function boundaryCheck(initialXY, dx, dy)
    proposedXY, endingLayer = calculateProposedPoint(initialXY, dx, dy)
    initX, initY = initialXY
    propX, propY = proposedXY
    endingStepSize = stepSizeDict[ endingLayer ]

    if inWalls(propX, propY)
        return sensWall(initialXY, dx, dy, endingStepSize), "no collision"
    elseif !inEscapeBounds(propX, propY)
        return undef, "escape"
    elseif inSensor(proposedXY)
        return undef, sensorCases(initX)
    else
        return proposedXY, "no collision"
    end
end

function sensorCases(initX)
    if inCenterSensorX(initX)
        return "center sensor"
    elseif initX < 0
        position = "left"
    else
        position = "right"
    end

    if inInnerSensorX(initX)
        return position * " inner sensor"
    elseif inOuterSensorX(initX)
        return position * " outer sensor"
    else
        println("sensorCases error ", initX)
        return "sensorCases error"
    end
end

# when we do the top enzyme case
# function wallCases(initialXY)
#     initX, initY = initialXY
#     if initY <= wallY
#         return "side wall"
#     elseif initY > wallY
#         if inCenterWallsX(initX)
#             return "top wall"
#         elseif inInnerWallsX(initX)
#             return "top wall"
#         elseif inOuterWallsX(initX)
#             return "top wall"
#         end
#     end
#
#     if rand(Float64) > 0.5
#         return "sidewall"
#     else
#         return "top wall"
# end
