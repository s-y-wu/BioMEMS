"""
    find_enzstepsize([enz_stepsizetotest, seed]) -> DataFrame

Run controlled thick and thin enz experiments at different enz step sizes
as defined by an array input.

Other simulation controls include:
    set_MAX_STEPS_PER_WALK()
    set_NUMBER_OF_WALKS()
Lab data shows thin enzyme has ~ double the yield of thick enzyme, so
target when the sensor receives half as many peroxides at the thicker parameter
"""
function find_enzstepsize(enz_stepsizetotest::Array{Float64, 1}=[0.005], seed::Int=randseed())
    find_enz_print()
    ss_arr, sensor_arr, escape_arr, unresv_arr, thick_arr = ([], [], [], [], [])
    for ss in enz_stepsizetotest
        for thickorthin in [true, false]
            set_THICK_ENZ(thickorthin)
            set_ENZ_STEP_SIZE(ss)
            append!(ss_arr, ss)

            data = Dict{String,Integer}()
            data["sensor"]  = 0
            data["escape"] = 0
            data["particles unresolved"] = 0
            data = run_sim!(data, seed)
            append!(sensor_arr, data["sensor"])
            append!(escape_arr, data["escape"])
            append!(unresv_arr, data["particles unresolved"])
            if thickorthin
                push!(thick_arr, "thick, $ENZYME_MAX_Y um")
            else
                push!(thick_arr, "thin, $ENZYME_MAX_Y um")
            end
        end
    end
    df = DataFrame(
        thick_or_thin = thick_arr,
        enz_step_size = ss_arr,
        sensor_yield = sensor_arr,
        escaped = escape_arr,
        unresolved = unresv_arr)
    return df
end

"Helper function, not exported in Enz module."
function find_enz_print()
    println("############################")
    println("   Compare Enz Step Sizes   ")
    println("############################")
    println("_________Parameters_________")
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    nothing
end

"""
    enz_sim([seed])

Run one simulation of the enz experiment with one sensor and no walls.

Simulation controls:
    set_THICK_ENZ() -> 2.0 um when true, 0.2 um when false
    set_ENZ_STEP_SIZE()
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
"""
function enz_sim(seed::Int=randseed())
    println("############################")
    println("       Enz Experiment       ")
    println("############################")
    println("_________Parameters_________")
    println("Enzyme Thickness:\t", string(ENZYME_MAX_Y))
    println("# of trials:\t\t", string(NUMBER_OF_WALKS))
    println("# of steps (max):\t", string(MAX_STEPS_PER_WALK))
    println("Step size, water:\t", string(WATER_STEP_SIZE))
    println("Step size, enz:\t\t", string(ENZ_STEP_SIZE))

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
