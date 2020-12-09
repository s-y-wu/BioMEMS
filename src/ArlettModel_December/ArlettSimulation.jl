# Model of Eleanor/Yoojin's Real Experiment, with flow
# Filename: arlettModel.jl
# Author(s): Sean Wu
# Last Updated: November 27, 2020

using DataFrames
using Dates

include("arlettParameters.jl")
include("boundaryCheck.jl")
include("boundaryCross.jl")
include("calcProposed.jl")
include("collision.jl")
include("flow.jl")
include("locationbools.jl")
include("oneStep.jl")
include("spawn.jl")


function saveAnimationData()
    x_arr, y_arr = animateArlettSimulation()
    df = DataFrame(x_coordinate = x_arr,
                    y_coordinate = y_arr)

    relativePath = "\\src\\ArlettModel_December\\animations\\"
    timeNow = string(Dates.now())
    # Microsoft File Name prohibits ":"
    newTime = replace(timeNow, ":" => ";")
    full_path = pwd() * relativePath * newTime * ".csv"
    CSV.write(full_path, df)
end


function animateArlettSimulation()
    x_arr = []
    y_arr = []
    peroxideXY = spawnRandomPoint()
    index = 0
    everyNthFrame = 10
    while peroxideXY != undef && index < MAX_STEPS_PER_WALK
        if index % everyNthFrame == 0
            x, y = peroxideXY
            compressedX = convert(Float16, x)
            compressedY = convert(Float16, y)
            push!(x_arr, compressedX)
            push!(y_arr, compressedY)
        end
        peroxideXY, newTally = oneStep(peroxideXY)
        index += 1
    end
    return x_arr, y_arr
end

function fullCollisionData()
    println("Arlett Model: Walls + Overflow Spawn + 1 Thick Enzymatic + 5 PPD + Flow")
    println("Particles: $NUMBER_OF_WALKS \t  Steps: $MAX_STEPS_PER_WALK\t Step lengths: $stepSizeDict")

    data = Dict{String,Integer}()
    data["side wall"] = 0
    data["top wall"] = 0
    data["escape"] = 0

    data["left outer sensor"] = 0
    data["left inner sensor"] = 0
    data["center sensor"] = 0
    data["right inner sensor"] = 0
    data["right outer sensor"] = 0

    data["particles unresolved"] = 0

    for _ in 1:NUMBER_OF_WALKS
        peroxideXY = spawnRandomPoint()
        index = 0
        while peroxideXY != undef && index < MAX_STEPS_PER_WALK
            peroxideXY, collision = oneStep(peroxideXY)
            if collision != "no collision"
                data[collision] += 1
            end
            index += 1
        end

        if index >= MAX_STEPS_PER_WALK
            data["particles unresolved"] += 1
        end
    end
    # present data in command line
    for keyVal in data
        extraSpacing = ""
        if length(keyVal[1]) < 14
            multiplier = 13 ÷ length(keyVal[1])
            extraSpacing = repeat("\t", multiplier)
        end
        println(keyVal[1], "\t", extraSpacing, keyVal[2])
    end
end
