# Model of Eleanor/Yoojin's Real Experiment, without flow
# Filename: a_NoFlowData.jl
# Author(s): Sean Wu
# Last Updated: December 6, 2020

using Random
using DataFrames

include("PARAMETERS_Arlett.jl")
include("Locations_Arlett.jl")
include("Flow_Arlett.jl")
include("Spawn_Arlett.jl")
include(pwd() * "\\src\\WalkLogic\\WalkLogic.jl")
include(pwd() * "\\src\\ViewOut\\UseData.jl")

"
    saveNoFlowData
Save data from a no flow Arlett simulation.

Runtime 12/8: 89.5 seconds for 100 runs
Runtime 12/10:
"
function savesimulation_arlettnoflow(seed::Int=randseed())
    df = runsimulation_arlettnoflow()
    seedstring = string(seed)
    savedata(df, "\\out\\noflowdata\\", seedstring)
    return nothing
end

function runsimulation_arlettnoflow(seed::Int=randseed())::DataFrame
    Random.seed!(seed)
    println("Begin No Flow Simulation. Seed: $seed")
    n_array = []
    innercrosstalk_array = []
    outercrosstalk_array = []
    center = 0
    inner = 0
    outer = 0
    innercrosstalk = 0.0
    outercrosstalk = 0.0

    float_arr = rand(NUMBER_OF_WALKS)
    for n in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr[n])
        steps_sofar = 0

        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = onestep!(peroxidexy)
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
                    innercrosstalk = 50.0 * inner / center
                    outercrosstalk = 50.0 * outer / center
                else
                    if inner > 0
                        innercrosstalk = 100.0
                    elseif outer > 0
                        outercrosstalk = 100.0
                    end
                end
                append!(n_array, n)
                append!(innercrosstalk_array, innercrosstalk)
                append!(outercrosstalk_array, outercrosstalk)
            end
            steps_sofar += 1
        end
    end

    df = DataFrame(
        nth_trial = n_array,
        inner_crosstalk = innercrosstalk_array,
        outer_crosstalk = outercrosstalk_array)
    return df
end