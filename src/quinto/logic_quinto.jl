const src_dir = dirname(normpath(@__DIR__, ".."))
include(string(src_dir, "/walk_logic/run_sim!.jl"))
include(string(src_dir, "/walk_logic/one_step!.jl"))
include(string(src_dir, "/walk_logic/approach_wall!.jl"))

"""
    boundary_check(initxy, dx, dy) -> Tuple{Array{Float64,1}, String}

Confirm the next coordinates after initxy with unit displacement vectors dx, dy.

Resolve collisions with escape boundaries, sensors, and walls.
"""
function boundary_check(initxy::Array{Float64,1}, dx::Float64, dy::Float64)
    proposedxy, endinglayer = evaluate_proposed(initxy, dx, dy)
    initx, inity = initxy
    propx, propy = proposedxy
    endingstepsize = STEP_SIZE_DICT[ endinglayer ]

    if inwalls(propx, propy)
        return wallcases(initxy, dx, dy, endingstepsize)
    elseif !inescapebounds(propx, propy)
        return undef, "escape"
    elseif insensor(proposedxy)
        return undef, sensorcases(propx) # not sensorcases(initx) in walls walk_logic
    else
        return proposedxy, "no collision"
    end
end

"sort between the four identical sensors"
function sensorcases(propx::Float64)::String
    if inspawnsensorx(propx)
        return "spawn sensor"
    elseif insecondsensorx(propx)
        return "second sensor"
    elseif inthirdsensorx(propx)
        return "third sensor"
    elseif infourthsensorx(propx)
        return "fourth sensor"
    end
end

"No side or top wall collision"
function wallcases(initxy::Array{Float64,1},
                   dx::Float64, dy::Float64,
                   ending_step_size::Float64)
    return approach_wall!(initxy, dx, dy, ending_step_size), "no collision"
end

"""
Same as walk_logic
"""
function north!(proposedxy::Array{Float64,1},
                initialxy::Array{Float64,1},
                dx::Float64, dy::Float64,
                start::String, endup::String)
    initx, inity = initialxy
    propx, propy = proposedxy
    scale = STEP_SIZE_DICT[start]
    scale2 = STEP_SIZE_DICT[endup]
    slope = (propx - initx) / (propy - inity)           # Reciprocal of traditional slope (delta x over delta y)

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

"""
    eastwest!(proposedxy, initialxy, dx, dy, start, endup, EastORWest) -> Array{Float64,1}

Corrects displacement vectors with head and tail in two different layers and
crossing the vertical boundary between water-enzyme, ppd-enzyme.
"""
function eastwest!(proposedxy::Array{Float64,1},
                    initialxy::Array{Float64,1},
                    dx::Float64, dy::Float64,
                    start::String, endup::String,
                    EastOrWest::String)
    initx, inity = initialxy
    propx, propy = proposedxy
    scale = STEP_SIZE_DICT[start]
    scale2 = STEP_SIZE_DICT[endup]
    slope = (propy - inity) / (propx - initx)           # Traditional slope (delta y over delta x)

    enzwater = start == "water" || endup == "water"
    if EastOrWest == "E"
        if enzwater
            xintersection = ENZYME_RIGHT_X
        else
            xintersection = PPD_RIGHT_X
        end
    else
        if enzwater
            xintersection = ENZYME_LEFT_X
        else
            xintersection = PPD_LEFT_X
        end
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

"""
    evaluate_proposed(initxy, dx, dy) -> Tuple{Array{Float64,1},String}

Identify location of xy coordinate and compute correct steplengths/displacement vectors.
"""
function evaluate_proposed(initxy::Array{Float64,1}, dx::Float64, dy::Float64)
    adjustedxy, whichsensor = adjustxy(initxy)
    if inwater(adjustedxy)
        newxy, endinglayer = watercalc(adjustedxy, dx, dy)
    elseif inenz(adjustedxy)
        newxy, endinglayer = enzcalc(adjustedxy, dx, dy)
    elseif inppd(adjustedxy)
        newxy, endinglayer = ppdcalc(adjustedxy, dx, dy)
    else
        println("evaluate_proposed Error", initxy)
        return [-1.0, -1.0], "evaluate_proposed Error"
    end
    return revertxy(newxy, whichsensor), endinglayer
end

"Helper when xy is initially in water"
function watercalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    proposedxy = [initx + WATER_STEP_SIZE * dx, inity + WATER_STEP_SIZE * dy]

    if inwater(proposedxy)
        return proposedxy, "water"
    elseif inenz(proposedxy)
        directionOfEntry = whereoutsideenz(initxy) # tail in water
        if directionOfEntry == "whereoutsideenz Error"
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
        print("Water to ppd is impossible in Quinto", initxy, proposedxy)
    else # collision
        return proposedxy, "water"
    end
end

"Helper when xy is initially in the enzyme layer"
function enzcalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    proposedxy = [initx + ENZ_STEP_SIZE * dx, inity + ENZ_STEP_SIZE * dy]

    if inenz(proposedxy)
        return proposedxy, "enz"
    elseif inwater(proposedxy)
        directionOfEntry = whereoutsideenz(proposedxy) # head in water
        if directionOfEntry == "whereoutsideenz Error"
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
        directionOfEntry = whereoutsideppd(initxy) # head in water
        if directionOfEntry == "whereoutsideppd Error"
            println(directionOfEntry, " in enzcalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north!(proposedxy, initxy, dx, dy, "enz", "ppd")
        elseif directionOfEntry == "NE"
            confirmxy = ENZ_TO_PPD_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = ENZ_TO_PPD_NORTHWEST
        else # E or W
            confirmxy = eastwest!(proposedxy, initxy, dx, dy, "enz", "ppd", directionOfEntry)
        end
        return confirmxy, "ppd"
    else # collision
        return proposedxy, "enz"
    end
end

"Helper when xy is initially in the ppd layer"
function ppdcalc(initxy::Array{Float64,1}, dx::Float64, dy::Float64)::Tuple{Array{Float64,1},String}
    initx, inity = initxy
    PPD_STEP_SIZE = STEP_SIZE_DICT["ppd"]
    proposedxy = [initx + PPD_STEP_SIZE * dx, inity + PPD_STEP_SIZE * dy] # no flow

    if inppd(proposedxy)
        return proposedxy, "ppd"
    elseif inenz(proposedxy)
        directionOfEntry = whereoutsideppd(proposedxy) # head in water
        if directionOfEntry == "whereoutsideppd Error"
            println(directionOfEntry, " in enzcalc ", initxy, proposedxy)
        elseif directionOfEntry == "N"
            confirmxy = north!(proposedxy, initxy, dx, dy, "ppd", "enz")
        elseif directionOfEntry == "NE"
            confirmxy = PPD_TO_ENZ_NORTHEAST
        elseif directionOfEntry == "NW"
            confirmxy = PPD_TO_ENZ_NORTHWEST
        else # E or W
            confirmxy = eastwest!(proposedxy, initxy, dx, dy, "ppd", "enz", directionOfEntry)
        end
        return confirmxy, "ppd"
    elseif inwater(proposedxy)
        print("PPD to water is impossible in Quinto", initxy, proposedxy)
    else # collision
        return proposedxy, "ppd"
    end
end
