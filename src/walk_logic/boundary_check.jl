# Author: Sean Wu
# Last Updated: November 12, 2020

# using Documenter
using Random


"""
    boundary_check

Confirm the next coordinates after initxy with unit displacement vectors
dx, dy. Resolve collisions with escape boundaries, sensors, and walls.
"""
function boundary_check(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    proposedxy, endingLayer = evaluate_proposed(initxy, dx, dy)
    initx, inity = initxy
    propx, propy = proposedxy
    endingStepSize = STEP_SIZE_DICT[ endingLayer ]

    if inwalls(propx, propy)
        return approach_wall!(initxy, dx, dy, endingStepSize), "no collision"
    elseif !inescapebounds(propx, propy)
        return undef, "escape"
    elseif insensor(proposedxy)
        return undef, sensorcases(initx)
    else
        return proposedxy, "no collision"
    end
end

# when we do the top enzyme case
# function wallcases(initxy::Array{Float64,1})::String
#     initx, inity = initxy
#     if inity <= WALL_Y
#         return "side wall"
#     elseif inity > WALL_Y
#         if incenterwallsx(initx)
#             return "top wall"
#         elseif ininnerwallsx(initx)
#             return "top wall"
#         elseif inouterwallsx(initx)
#             return "top wall"
#         end
#     end
#
#     if rand(Float64) > 0.5
#         return "side wall"
#     else
#         return "top wall"
# end
