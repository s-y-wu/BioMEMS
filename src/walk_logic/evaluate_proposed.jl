# Author: Sean Wu
# Last Updated: November 11, 2020

"Manages steplength calculations and adjusts the steplength by layers accordingly."
function evaluate_proposed(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    if inwater(initxy)
        return watercalc(initxy, dx, dy)
    elseif inenz(initxy)
        return enzcalc(initxy, dx, dy)
    elseif inppd(initxy)
        return ppdcalc(initxy, dx, dy)
    else
        println("evaluate_proposed Error", initxy)
        return [-1.0, -1.0], "evaluate_proposed Error"
    end
end

function watercalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    flowBias = flow_arlett(initxy)
    proposedxy = [initx + flowBias + WATER_STEP_SIZE * dx, inity + WATER_STEP_SIZE * dy]

    if inwater(proposedxy)
        return proposedxy, "water"
    elseif inenz(proposedxy)
        directionOfEntry = whereoutsidespawn(initxy) # tail in water
        if directionOfEntry == "whereoutsidespawn Error"
            println(directionOfEntry, " in watercalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north!(proposedxy, initxy, dx, dy, "water", "enz")
        elseif directionOfEntry == "NE"
            confirmxy = WATER_TO_ENZ_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = WATER_TO_ENZ_NORTHWEST
        else # E or W
            confirmxy = eastwest!(proposedxy, initxy, dx, dy, "water", "enz", directionOfEntry)
        end
        return confirmxy, "enz"
    elseif inppd(proposedxy)
        confirmxy = north!(proposedxy, initxy, dx, dy, "water", "ppd")
        return confirmxy, "ppd"
    else # collision
        return proposedxy, "water"
    end
end

function enzcalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    flowBias = flow_arlett(initxy) * ENZ_STEP_SIZE / WATER_STEP_SIZE
    proposedxy = [initx + flowBias + ENZ_STEP_SIZE * dx, inity + ENZ_STEP_SIZE * dy]

    if inenz(proposedxy)
        return proposedxy, "enz"
    elseif inwater(proposedxy)
        directionOfEntry = whereoutsidespawn(proposedxy) # head in water
        if directionOfEntry == "whereoutsidespawn Error"
            println(directionOfEntry, " in enzcalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north!(proposedxy, initxy, dx, dy, "enz", "water")
        elseif directionOfEntry == "NE"
            confirmxy = ENZ_TO_WATER_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = ENZ_TO_WATER_NORTHWEST
        else # E or W
            confirmxy = eastwest!(proposedxy, initxy, dx, dy, "enz", "water", directionOfEntry)
        end
        return confirmxy, "water"
    elseif inppd(proposedxy)
        confirmxy = north!(proposedxy, initxy, dx, dy, "enz", "ppd")
        return confirmxy, "ppd"
    else # collision
        return proposedxy, "enz"
    end
end

function ppdcalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    PPD_STEP_SIZE = STEP_SIZE_DICT["ppd"]
    proposedxy = [initx + PPD_STEP_SIZE * dx, inity + PPD_STEP_SIZE * dy] # no flow

    if inppd(proposedxy)
        return proposedxy, "ppd"
    elseif inenz(proposedxy)
        confirmxy = north!(proposedxy, initxy, dx, dy, "ppd", "enz")
        return confirmxy, "enz"
    elseif inwater(proposedxy)
        confirmxy = north!(proposedxy, initxy, dx, dy, "ppd", "water")
        return confirmxy, "water"
    else # collision
        return proposedxy, "ppd"
    end
end
