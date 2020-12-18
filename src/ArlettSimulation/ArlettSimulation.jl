# Model of Eleanor/Yoojin's Real Experiment, with flow
# Filename: arlettModel.jl
# Author(s): Sean Wu
# Last Updated: November 27, 2020

using Random
using DataFrames

include("PARAMETERS_Arlett.jl")
include("Locations_Arlett.jl")
include("Flow_Arlett.jl")
include("Spawn_Arlett.jl")
include(pwd() * "\\src\\WalkLogic\\WalkLogic.jl")
include(pwd() * "\\src\\ViewOut\\UseData.jl")

function runsimulation_arlett(seed::Int=randseed())
    println("Arlett Model: Walls + Overflow Spawn + 1 Thick Enzyme + 5 PPD + Flow")
    println("Particles: $NUMBER_OF_WALKS \t  Steps: $MAX_STEPS_PER_WALK\t Step lengths: $STEP_SIZE_DICT")
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

    output = runsimulation!(data, seed)
    presentdata_arlett(output)
    return nothing
end

function presentdata_arlett(output_data::Dict{String, Integer})
    presentationOrder = ["side wall",
        "top wall",
        "left outer sensor",
        "left inner sensor",
        "center sensor",
        "right inner sensor",
        "right outer sensor",
        "escape",
        "particles unresolved",
        "avg steps taken"]
    for key in presentationOrder
        extraSpacing = ""
        if length(key) < 14
            multiplier = 13 ÷ length(key)
            extraSpacing = repeat("\t", multiplier)
        end
        println(key, "\t", extraSpacing, output_data[key])
    end
    return nothing
end
