"""
    arlett_sim([seed])

Run the random walk simulation of Yoojin/Eleanor's experiments.

Simulation controls:
    set_FLOW_BIAS()
    set_CATALASE_ON_WALLS()
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WAL()
"""
function arlett_sim(seed::Int=randseed())
    arlett_print()
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
    output = run_sim!(data, seed)
    present_arlett_data(output)
    nothing
end

"Helper function to start, not exported in Arlett module"
function arlett_print()
    println("############################")
    println("      Arlett Simulation     ")
    println("############################")
    println("_________Parameters_________")
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    println("Step size, enz:\t\t", string(ENZ_STEP_SIZE))
    println("Step size, ppd:\t\t", string(PPD_STEP_SIZE))
    println("Flow Bias On:\t\t", string(FLOW_BIAS))
    println("Catalase on walls:\t", string(CATALASE_ON_WALLS))
    nothing
end

"Helper function to end, not exported in Arlett module"
function present_arlett_data(data::Dict{String, Integer})
    println("_________Results____________")
    println("Side wall collisions:\t", data["side wall"])
    if CATALASE_ON_WALLS
        println("# caught by catalase:\t", data["top wall"])
    else
        println("Top wall collisions:\t", data["top wall"])
    end
    println("Escaped\t\t\t", data["escape"])
    println("*Sensors from Left to Right*")
    println("# in first:\t\t", data["left outer sensor"])
    println("# in second:\t\t", data["left inner sensor"])
    println("# in third (spawn):\t", data["center sensor"])
    println("# in fourth:\t\t", data["right inner sensor"])
    println("# in fifth:\t\t", data["right outer sensor"])
    println("# unresolved:\t\t", data["particles unresolved"])
    println("Average steps taken:\t", data["avg steps taken"])
    nothing
end
