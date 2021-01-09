# Author: Sean Wu
# First Written: December 15


"""
    getdata_ppdstepsize([ppd_stepsizestotest, seed]) -> DataFrame

Run controlled ppd experiments at different ppd step sizes (input in an array).

Other simulation controls include:
    set_PPD_ON() -> IMPORTANT: Make sure PPD_ON is true before running.
    set_MAX_STEPS_PER_WALK()
    set_NUMBER_OF_WALKS()
Lab data shows no ppd experiments (ppd stepsize = 0.1) sees double the yield of ppd.
Target when the sensor receives half as many peroxides with smaller ppd stepsizes.
"""
function getdata_ppdstepsize(ppd_stepsizestotest::Array{Float64, 1}=[0.001], seed::Int=randseed())
    ppd_print(seed)
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
    df = DataFrame(ppd_step_size = ss_arr,
        sensor_yield = sensor_arr,
        escaped = escape_arr,
        unresolved = unresv_arr)
    current_df(df)
    current_seed(seed)
    current_path("out/ppddata/")
    return df
end

"Helper function to print parameters, not exported in PPD module"
function ppd_print(seed::Int)
    println("############################")
    println("   Compare PPD Step Sizes   ")
    println("############################")
    println("_________Parameters_________")
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    println("Random seed:\t\t$seed")
    nothing
end

"""
    ppd_sim([seed])

Run one simulation of the ppd experiment with one sensor in a well.

Simulation controls:
    set_PPD_ON() -> if PPD_ON === false, then PPD_STEP_SIZE = WATER_STEP_SIZE
    set_MAX_STEPS_PER_WALK()
    set_NUMBER_OF_WALKS()
    set_PPD_STEP_SIZE()
"""
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
    println("Random seed:\t\t$seed")

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
