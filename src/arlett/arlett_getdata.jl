"
    getdata_arlett_catalase([Int]) -> DataFrame

Enable wall catalase, run the Arlett simulation, and revert controls.

For each walk that ends in a sensor collision, return
    1. the trial #
    2. inner sensor cross talk, left and right
    3. outer sensor cross talk, left and right
in a DataFrame.

Simulation controls:
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
"
function getdata_arlett_noflowcatalase(seed::Int=randseed())
    init_CATALASE = CATALASE_ON_WALLS
    init_FLOW_BIAS = FLOW_BIAS
    set_FLOW_BIAS(false)
    set_CATALASE_ON_WALLS(true)

    df = getdata_arlett(seed)

    current_path("out/noflowcatalase/")
    set_CATALASE_ON_WALLS(init_CATALASE)
    set_FLOW_BIAS(init_FLOW_BIAS)
    return df
end

"
    getdata_arlett_flow([Int]) -> DataFrame

Enable flow bias, run the Arlett simulation, and revert controls.

For each walk that ends in a sensor collision, return
    1. the trial #
    2. inner sensor cross talk, left and right
    3. outer sensor cross talk, left and right
in a DataFrame.

Simulation controls:
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
"
function getdata_arlett_flow(seed::Int=randseed())
    init_FLOW_BIAS = FLOW_BIAS
    init_CATALASE = CATALASE_ON_WALLS
    set_FLOW_BIAS(true)
    set_CATALASE_ON_WALLS(false)

    df = getdata_arlett(seed)

    current_path("out/flowdata/")
    set_FLOW_BIAS(init_FLOW_BIAS)
    set_CATALASE_ON_WALLS(init_CATALASE)
    return df
end

"
    getdata_arlett_noflow([Int]) -> DataFrame

Disable flow bias/wall-catalase, run the Arlett simulation, and revert controls.

For each walk that ends in a sensor collision, return
    1. the trial #
    2. inner sensor cross talk, average of left and right
    3. outer sensor cross talk, average of left and right
in a DataFrame.

Simulation controls:
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
"
function getdata_arlett_noflow(seed::Int=randseed())
    init_FLOW_BIAS = FLOW_BIAS
    init_CATALASE = CATALASE_ON_WALLS
    set_FLOW_BIAS(false)
    set_CATALASE_ON_WALLS(false)

    df = getdata_arlett(seed)

    current_path("out/noflowdata/")
    set_FLOW_BIAS(init_FLOW_BIAS)
    set_CATALASE_ON_WALLS(init_CATALASE)
    return df
end

"Helper function for all getdata_arlett"
function getdata_arlett(seed)
    Random.seed!(seed)
    float_arr = rand(NUMBER_OF_WALKS)
    stub_arr = rand(NUMBER_OF_WALKS) # for consistency with run_sim!()
    arlett_print(seed)
    n_array = []
    leftouter_array = []; leftinner_array = []
    rightinner_array = []; rightouter_array = []
    leftouter, leftinner, center, rightinner, rightouter = (0, 0, 0, 0, 0)
    leftouter_ctalk = 0.0; leftinner_ctalk = 0.0
    rightinner_ctalk = 0.0; rightouter_ctalk = 0.0
    # Record data between trials instead of only the end using run_sim!()
    @showprogress for n in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr[n])
        steps_sofar = 0
        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = one_step!(peroxidexy)
            steps_sofar += 1
            if collision == "left outer sensor"
                leftouter += 1
            elseif collision == "left inner sensor"
                leftinner += 1
            elseif collision == "center sensor"
                center += 1
            elseif collision == "right inner sensor"
                rightinner += 1
            elseif collision == "right outer sensor"
                rightouter += 1
            end
        end
        if center > 0
            leftouter_ctalk = 100.0 * leftouter / center
            leftinner_ctalk = 100.0 * leftinner / center
            rightinner_ctalk = 100.0 * rightinner / center
            rightouter_ctalk = 100.0 * rightouter / center
        else
            if leftouter > 0
                leftouter_ctalk = 100.0
            end
            if leftinner > 0
                leftinner_ctalk = 100.0
            end
            if rightinner > 0
                rightinner_ctalk = 100.0
            end
            if rightouter > 0
                rightouter_ctalk = 100.0
            end
        end
        append!(n_array, n)
        append!(leftouter_array, leftouter_ctalk)
        append!(leftinner_array, leftinner_ctalk)
        append!(rightinner_array, rightinner_ctalk)
        append!(rightouter_array, rightouter_ctalk)
    end
    df = DataFrame(
        nth_trial = n_array,
        left_outer_crosstalk = leftouter_array,
        left_inner_crosstalk = leftinner_array,
        right_inner_crosstalk = rightinner_array,
        right_outer_crosstalk = rightouter_array
    )
    current_df(df)
    current_seed(seed)
    return df
end
