# Author: Sean Wu
# Last Updated: November 11, 2020

#include("Flow.jl")
#include("BoundaryCross.jl")
#include("Spawn.jl")
#include("LocationBools.jl")

"Manages steplength calculations and adjusts the steplength by layers accordingly."
function calculateproposedpoint(initxy, dx, dy)
    if inWater(initxy)
        return watercalc(initxy, dx, dy)
    elseif inEnz(initxy)
        return enzcalc(initxy, dx, dy)
    elseif inPPD(initxy)
        return ppdcalc(initxy, dx, dy)
    else
        println("calcPropPoint Error", initxy)
        return undef, 0
    end
end

function watercalc(initxy, dx, dy)
    initx, inity = initxy
    flowBias = flow(initxy)
    proposedxy = [initx + flowBias + WATER_STEP_SIZE * dx, inity + WATER_STEP_SIZE * dy]

    if inWater(proposedxy)
        return proposedxy, "water"
    elseif inEnz(proposedxy)
        directionOfEntry = whereOutsideSpawn(initxy) # tail in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in watercalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north(initxy, proposedxy, dx, dy, "water", "enz")
        elseif directionOfEntry == "NE"
            confirmxy = WATER_TO_ENZ_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = WATER_TO_ENZ_NORTHWEST
        else # E or W
            confirmxy = eastwest(initxy, proposedxy, dx, dy, "water", "enz", directionOfEntry)
        end
        return confirmxy, "enz"
    elseif inPPD(proposedxy)
        confirmxy = north(initxy, proposedxy, dx, dy, "water", "ppd")
        return confirmxy, "ppd"
    else # collision
        return proposedxy, "water"
    end
end

function enzcalc(initxy, dx, dy)
    initx, inity = initxy
    flowBias = flow(initxy) * ENZ_STEP_SIZE / WATER_STEP_SIZE
    proposedxy = [initx + flowBias + ENZ_STEP_SIZE * dx, inity + ENZ_STEP_SIZE * dy]

    if inEnz(proposedxy)
        return proposedxy, "enz"
    elseif inWater(proposedxy)
        directionOfEntry = whereOutsideSpawn(proposedxy) # head in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in enzcalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north(initxy, proposedxy, dx, dy, "enz", "water")
        elseif directionOfEntry == "NE"
            confirmxy = ENZ_TO_WATER_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = ENZ_TO_WATER_NORTHWEST
        else # E or W
            confirmxy = eastwest(initxy, proposedxy, dx, dy, "enz", "water", directionOfEntry)
        end
        return confirmxy, "water"
    elseif inPPD(proposedxy)
        confirmxy = north(initxy, proposedxy, dx, dy, "enz", "ppd")
        return confirmxy, "ppd"
    else # collision
        return proposedxy, "enz"
    end
end

function ppdcalc(initxy, dx, dy)
    initx, inity = initxy
    PPD_STEP_SIZE = STEP_SIZE_DICT["ppd"]
    proposedxy = [initx + PPD_STEP_SIZE * dx, inity + PPD_STEP_SIZE * dy] # no flow

    if inPPD(proposedxy)
        return proposedxy, "ppd"
    elseif inEnz(proposedxy)
        confirmxy = north(initxy, proposedxy, dx, dy, "ppd", "enz")
        return confirmxy, "enz"
    elseif inWater(proposedxy)
        confirmxy = north(initxy, proposedxy, dx, dy, "ppd", "water")
        return confirmxy, "water"
    else # collision
        return proposedxy, "ppd"
    end
end
