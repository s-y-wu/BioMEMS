# Author: Sean Wu
# Last Updated: November 11, 2020

"required imports for unit testing"
#include("Flow.jl")
#include("BoundaryCross.jl")
#include("Spawn.jl")
#include("LocationBools.jl")

"Manages steplength calculations and adjusts the steplength by layers accordingly."
function calculateProposedPoint(initialXY, dx, dy)
    if inWater(initialXY)
        return waterCalc(initialXY, dx, dy)
    elseif inEnz(initialXY)
        return enzCalc(initialXY, dx, dy)
    elseif inPPD(initialXY)
        return ppdCalc(initialXY, dx, dy)
    else
        println("calcPropPoint Error", initialXY)
        return undef, 0
    end
end

function waterCalc(initialXY, dx, dy)
    initX, initY = initialXY
    flowBias = flow(initialXY)
    proposedXY = [initX + flowBias + waterStepSize * dx, initY + waterStepSize * dy]

    if inWater(proposedXY)
        return proposedXY, "water"
    elseif inEnz(proposedXY)
        directionOfEntry = whereOutsideSpawn(initialXY) # tail in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in waterCalc ", initialXY, proposedXY)
        elseif directionOfEntry == "N"
            confirmXY = North(initialXY, proposedXY, dx, dy, "water", "enz")
        elseif directionOfEntry == "NE"
            confirmXY = waterToEnzNorthEast
        elseif directionOfEntry == "NW"
            confirmXY = waterToEnzNorthWest
        else # E or W
            confirmXY = EastWest(initialXY, proposedXY, dx, dy, "water", "enz", directionOfEntry)
        end
        return confirmXY, "enz"
    elseif inPPD(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "water", "ppd")
        return confirmXY, "ppd"
    else # collision
        return proposedXY, "water"
    end
end

function enzCalc(initialXY, dx, dy)
    initX, initY = initialXY
    flowBias = flow(initialXY) * enzStepSize / waterStepSize
    proposedXY = [initX + flowBias + enzStepSize * dx, initY + enzStepSize * dy]

    if inEnz(proposedXY)
        return proposedXY, "enz"
    elseif inWater(proposedXY)
        directionOfEntry = whereOutsideSpawn(proposedXY) # head in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in enzCalc ", initialXY, proposedXY)
        elseif directionOfEntry == "N"
            confirmXY = North(initialXY, proposedXY, dx, dy, "enz", "water")
        elseif directionOfEntry == "NE"
            confirmXY = enzToWaterNorthEast
        elseif directionOfEntry == "NW"
            confirmXY = enzToWaterNorthWest
        else # E or W
            confirmXY = EastWest(initialXY, proposedXY, dx, dy, "enz", "water", directionOfEntry)
        end
        return confirmXY, "water"
    elseif inPPD(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "enz", "ppd")
        return confirmXY, "ppd"
    else # collision
        return proposedXY, "enz"
    end
end

function ppdCalc(initialXY, dx, dy)
    initX, initY = initialXY
    ppdStepSize = stepSizeDict["ppd"]
    proposedXY = [initX + ppdStepSize * dx, initY + ppdStepSize * dy] # no flow

    if inPPD(proposedXY)
        return proposedXY, "ppd"
    elseif inEnz(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "ppd", "enz")
        return confirmXY, "enz"
    elseif inWater(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "ppd", "water")
        return confirmXY, "water"
    else # collision
        return proposedXY, "ppd"
    end
end
