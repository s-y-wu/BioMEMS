# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")

"Corrects displacement vectors with head and tail at two different layers"

"At horizontal boundary between water-enzyme, water-ppd, or ppd-enzyme"
function north!(proposedxy::Array{Float64,1}, initialxy::Array{Float64,1}, dx::Float, dy::Float, start::String, endup::String)::Array{Float64,1}
    initx, inity = initialxy
    scale = STEP_SIZE_DICT[start]
    scale2 = STEP_SIZE_DICT[endup]
    slope = (proposedxy[1] - initx) / (proposedxy[2] - inity)           # Reciprocal of traditional slope (delta x over delta y)

    if start == "ppd" || endup == "ppd"
        yintersection = PPD_MAX_Y
    else
        yintersection = ENZYME_MAX_Y
    end

    xintersection = slope * (yintersection - inity) + initx         # x-component of the head of first segment, ending at the border crossing
                # Reciprocal slope lets us multiply the change in y to obtain the change in x
    ydistleft = scale * dy + (inity - yintersection)                # y-component legnth of the original second segment
    xdistleft = scale * dx + (initx - xintersection)                # x-component length of the original second segment
    # First divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
    # Then multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
    # Lastly append the correct lengths of the new second segment to the head of the first segment vector
    proposedxy[1] = xintersection + xdistleft * scale2/scale
    proposedxy[2] = yintersection + ydistleft * scale2/scale
    return proposedxy
end

"At vertical boundary between enzyme and water. No ppd-water vertical boundary, only ppd-wall"
function eastwest!(proposedxy::Array{Float64,1}, initialxy::Array{Float64,1}, dx::Float64, dy::Float64, start::String, endup::String, EastOrWest::String)::Array{Float64,1}
    initx, inity = initialxy
    propx, propy = proposedxy
    scale = STEP_SIZE_DICT[start]
    scale2 = STEP_SIZE_DICT[endup]
    slope = (propy - inity) / (propx - initx)           # Traditional slope (delta y over delta x)

    if EastOrWest == "E"
        xintersection = ENZYME_RIGHT_X
    else
        xintersection = ENZYME_LEFT_X
    end

    yintersection = slope * (xintersection - initx) + inity         # y-component of the head of first segment, ending at the border crossing
                # Multiply the slope and the change in y to obtain the change in x
    xdistleft = scale * dx + (initx - xintersection)                # x-component legnth of the original second segment
    ydistleft = scale * dy + (inity - yintersection)                # y-component legnth of the original second segment
    # Divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
    # Multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
    # Append the correct lengths of the new second segment to the head of the first segment vector
    proposedxy[1] = xintersection + xdistleft * scale2/scale
    proposedxy[2] = yintersection + ydistleft * scale2/scale
    return proposedxy
end
