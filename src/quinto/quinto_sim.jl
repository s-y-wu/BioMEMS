include("PARAMETERS_quinto.jl")
include("locations_quinto.jl")
include("logic_quinto.jl")

"""
    quinto_sim([seed])

Run the random walk simulation of Yoojin/Eleanor's experiments.

Simulation controls:
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WAL()
"""
function quinto_sim(seed::Int=randseed())
    quinto_print(seed)
    data = Dict{String,Integer}()
    data["escape"] = 0
    data["spawn sensor"] = 0
    data["second sensor"] = 0
    data["third sensor"] = 0
    data["fourth sensor"] = 0
    data["particles unresolved"] = 0
    output = run_sim!(data, seed)
    present_quinto_data(output)
    nothing
end

"Helper function to start, not exported in Arlett module"
function quinto_print(seed::Int64)
    println("############################")
    println("      Quinto Simulation     ")
    println("############################")
    println("_________Parameters_________")
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    println("Step size, enz:\t\t", string(ENZ_STEP_SIZE))
    println("Step size, ppd:\t\t", string(PPD_STEP_SIZE))
    println("Random seed:\t\t$seed")
    nothing
end

"Helper function to end, not exported in Arlett module"
function present_quinto_data(data::Dict{String, Integer})
    println("_________Results____________")
    println("# escaped:\t\t", data["escape"])
    println("*Sensors from left to right*")
    println("# in first (spawn):\t", data["spawn sensor"])
    println("# in second:\t\t", data["second sensor"])
    println("# in third:\t\t", data["third sensor"])
    println("# in fourth:\t\t", data["fourth sensor"])
    println("# unresolved:\t\t", data["particles unresolved"])
    println("Average steps taken:\t", data["avg steps taken"])
    nothing
end
