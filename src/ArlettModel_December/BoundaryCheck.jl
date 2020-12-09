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

    if !inEscapeBounds(propX, propY)    # before wall for corner case
        return undef, "escape"
    elseif inSensor(proposedXY)
        return undef, sensorCases(initX)
    elseif inWalls(propX, propY)
        return sensWall(initialXY, dx, dy, endingStepSize), wallCases(initialXY)
    else
        return proposedXY, "no collision"
    end
end

function sensorCases(initX)
    if inCenterX(initX)
        return "center sensor"
    elseif initX < 0
        position = "left"
    else
        position = "right"
    end

    if inInnerAdjX(initX)
        return position * " inner sensor"
    elseif inOuterAdjX(initX)
        return position * " outer sensor"
    else
        println("sensorCases error ", initX)
        return "sensorCases error"
    end
end

function wallCases(initialXY)
    initX, initY = initialXY
    if initY <= 1.5
        return "side wall"
    elseif initY > 1.5 && inCenterX(initX) || inInnerAdjX(initX) || inOuterAdjX(initX)
        return "top wall"
    else
        cornerCase = Dict(0 => "side wall", 1 => "top wall")
        return cornerCase[bitrand()[1]] # coinflip rare ambiguous case
    end
end
