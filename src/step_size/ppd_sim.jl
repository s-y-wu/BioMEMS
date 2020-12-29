# Author: Sean Wu
# First Written: December 15

"Lab data shows no ppd has double the yield of ppd"

function find_ppdstepsize(ppd_stepsizestotest::Array{Float64, 1}=[0.001], seed::Int=randseed())::DataFrame
    find_ppd_print()
    ss_arr, sensor_arr, escape_arr, unresv_arr = ([], [], [], [])
    set_PPD_ON(true)
    for ss in ppd_stepsizestotest
        set_PPD_STEP_SIZE(ss)
        append!(ss_arr, ss)
        
        data = Dict{String,Integer}()
        data["sensor"]  = 0
        data["escape"] = 0
        data["particles unresolved"] = 0
        data = run_sim!(data, seed)
        append!(sensor_arr, data["sensor"])
        append!(escape_arr, data["escape"])
        append!(unresv_arr, data["particles unresolved"])
    end
    df = DataFrame(step_size = ss_arr,
        sensor_yield = sensor_arr,
        escaped = escape_arr,
        unresolved = unresv_arr)
    return df
end

function find_ppd_print()
    println("############################")
    println("   Compare PPD Step Sizes   ")
    println("############################")
    println("_________Parameters_________")
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    nothing
end

function ppd_sim(seed::Int=randseed())
    println("############################")
    println("       PPD Experiment       ")
    println("############################")
    println("_________Parameters_________")
    println("PPD on sensor:\t\t", string(PPD_ON))
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    if PPD_ON
        println("Step size, PPD:\t\t", string(PPD_STEP_SIZE))
    end

    data = Dict{String,Integer}()
    data["sensor"] = 0
    data["escape"] = 0
    data["particles unresolved"] = 0
    output = run_sim!(data, seed)

    println("_________Results____________")
    println("# in sensor:\t\t", string(data["sensor"]))
    println("# of escaped:\t\t", string(data["escape"]))
    println("# unresolved:\t\t", string(data["particles unresolved"]))
    nothing
end
