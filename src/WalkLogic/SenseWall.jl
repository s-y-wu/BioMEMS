# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")
#include("LocationBools.jl")

"Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector"
function sensewall!(initxy::Array{Float64,1}, dx::Float64, dy::Float64, stepSize::Float64)::Array{Float64,1}
    newx = initxy[1] + stepSize*dx
    newy = initxy[2] + stepSize*dy

    if inwalls(newx, newy)
        return sensewall!(initxy, dx, dy, stepSize * 0.5)
    else
        initxy[1] = newx
        initxy[2] = newy
        return initxy
    end
end
