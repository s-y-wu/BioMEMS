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

"   saveNoFlowData
Save data from a no flow Arlett simulation.

Runtime 12/8: 89.5 seconds for 100 runs
Runtime 12/10:
"
function saveNoFlowData(seed::Int64)
    Random.seed!(seed)
    saveNoFlowData(string(seed))
end

function saveNoFlowData()
    saveNoFlowData("")
end

function saveNoFlowData(seedStr::String)
    n_arr, in_arr, out_arr = runNoFlowSimulation()
    df = DataFrame(nth_trial = n_arr, innerXtalk = in_arr, outerXtalk = out_arr)

    relativePath = "\\src\\ArlettModel_December\\noFlowData\\"
    timeNow = string(Dates.now())
    # Microsoft File Name prohibits ":"
    newTime = replace(timeNow, ":" => ";")
    fileName = newTime * "_seed" * seedStr * ".csv"
    # example: "2020-12-07T20;41;59.177.csv"
    full_path = pwd() * relativePath * fileName
    CSV.write(full_path, df)
end

function runNoFlowSimulation()
    println("Begin cross talk recording (no flow)")
    n_array = []
    innerXtalk_array = []
    outerXtalk_array = []
    center = 0
    inner = 0
    outer = 0
    innerXtalk = 0.0
    outerXtalk = 0.0

    arrayOfRandomFloats = rand(NUMBER_OF_WALKS)
    for n in 1:NUMBER_OF_WALKS
        peroxideXY = spawnRandomPoint(arrayOfRandomFloats[n])
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
