# Model of Eleanor/Yoojin's Real Experiment, without flow
# Filename: a_NoFlowData.jl
# Author(s): Sean Wu
# Last Updated: December 6, 2020

using Plots
using Random
using DataFrames
using CSV
using Dates

include("ArlettParameters.jl")
include("BoundaryCheck.jl")
include("BoundaryCross.jl")
include("CalcProposed.jl")
include("Collision.jl")
include("Flow.jl")
include("Locationbools.jl")
include("OneStep.jl")
include("Spawn.jl")

"   saveSimulation
Save data from a no flow Arlett simulation."
function saveSimulation()
    n_arr, in_arr, out_arr = runSimulation()
    df = DataFrame(nth_trial = n_arr, innerXtalk = in_arr, outerXtalk = out_arr)

    path = "C://Users//sywu//.julia//dev//HMCResearchRandomWalks//src//ArlettModel_December//noFlowData//"
    timeNow = string(Dates.now())
    # Microsoft File Name prohibits ":"
    newTime = replace(timeNow, ":" => ";")
    # example: "2020-12-07T20;41;59.177"
    full_path = path * newTime * ".csv"

    CSV.write(full_path, df)
end

function runSimulation()
    println("Begin cross talk recording (no flow)")
    n_array = []
    innerXtalk_array = []
    outerXtalk_array = []
    center = 0
    inner = 0
    outer = 0
    innerXtalk = 0.0
    outerXtalk = 0.0

    for n in 1:NUMBER_OF_WALKS
        peroxideXY = spawnRandomPoint()
        index = 0

        while peroxideXY != undef && index < MAX_STEPS_PER_WALK
            peroxideXY, collision = oneStep(peroxideXY)
            update = false

            if collision == "left outer sensor" || collision == "right outer sensor"
                outer += 1
                update = true
            elseif collision == "left inner sensor" || collision == "right inner sensor"
                inner += 1
                update = true
            elseif collision == "center sensor"
                center += 1
                update = true
            end

            if update
                if center > 0
                    innerXtalk = 50.0 * inner / center
                    outerXtalk = 50.0 * outer / center
                else
                    if inner > 0
                        innerXtalk = 100.0
                    elseif outer > 0
                        outerXtalk = 100.0
                    end
                end
                append!(n_array, n)
                append!(innerXtalk_array, innerXtalk)
                append!(outerXtalk_array, outerXtalk)
            end
            index += 1
        end
    end

    return n_array, innerXtalk_array, outerXtalk_array
end
