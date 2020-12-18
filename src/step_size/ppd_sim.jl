# Author: Sean Wu
# First Written: December 15

using DataFrames
"Lab data shows no ppd has double the yield of ppd"

include("PARAMETERS_PPD.jl")
include("Locations_PPD.jl")
include(pwd() * "\\src\\ArlettSimulation\\Flow_Arlett.jl")
include(pwd() * "\\src\\WalkLogic\\WalkLogic.jl")
# include(pwd() * "\\src\\ViewOut\\UseData.jl")

function find_ppdstepsize(ppd_stepsizestotest::Array{Float64, 1}=[0.001])::DataFrame
    println("Compare PPD Step Sizes")
    println("PPD?: $PPD_ON")
    if !PPD_ON
        ppd_stepsizestotest = [WATER_STEP_SIZE]
    end
    ss_arr = []
    sensor_arr = []
    escape_arr = []
    unresv_arr = []

    for ss in ppd_stepsizestotest
        append!(ss_arr, ss)
        global PPD_STEP_SIZE = ss
        global STEP_SIZE_DICT = Dict("water" => WATER_STEP_SIZE, "enz" => ss, "ppd" => 0)
        data = callSimulation()
        append!(sensor_arr, data["sensor"])
        append!(escape_arr, data["escape"])
        append!(unresv_arr, data["particles unresolved"])
    end

    df = DataFrame(step_size = ss_arr,
        sensor_yield = sensor_arr,
        escaped = escape_arr,
        unresolved = unresv_arr,
        net_yield = netyield_arr)
    return df
end

function runsimulation_ppdstepsize(seed::Int=randseed())
    println("PPD Stepsize Derivation")
    println("PPD?: $PPD_ON \tSeed: $seed")
    println("Particles: $NUMBER_OF_WALKS \t Steps: $MAX_STEPS_PER_WALK\t Step lengths: $STEP_SIZE_DICT")
    data = Dict{String,Integer}()
    data["sensor"] = 0
    data["escape"] = 0
    data["particles unresolved"] = 0
    output = runsimulation!(data, seed)

    presentationOrder = ["sensor",
        "escape",
        "particles unresolved",
        "avg steps taken"]

    for key in presentationOrder
        println(key, "\t", output[key])
    end
    return nothing
end
