# Author: Sean Wu
# Last Updated: November 12, 2020

# using Documenter
using Random


"""
    boundary_check(initxy, dx, dy) -> Tuple{Array{Float64,1}, String}

Confirm the next coordinates after initxy with unit displacement vectors dx, dy.

Resolve collisions with escape boundaries, sensors, and walls.
"""
function boundary_check(initxy::Array{Float64,1}, dx::Float64, dy::Float64)
    proposedxy, endingLayer = evaluate_proposed(initxy, dx, dy)
    initx, inity = initxy
    propx, propy = proposedxy
    endingStepSize = STEP_SIZE_DICT[ endingLayer ]

    if inwalls(propx, propy)
        return wallcases(initxy, dx, dy, endingStepSize)
    elseif !inescapebounds(propx, propy)
        return undef, "escape"
    elseif insensor(proposedxy)
        return undef, sensorcases(initx)
    else
        return proposedxy, "no collision"
    end
end
