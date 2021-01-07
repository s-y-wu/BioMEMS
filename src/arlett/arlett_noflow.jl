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
    Random.seed!(seed)
    float_arr = rand(NUMBER_OF_WALKS)
    stub_arr = rand(NUMBER_OF_WALKS) # for consistency with run_sim!()

    init_FLOW_BIAS = FLOW_BIAS
    init_CATALASE = CATALASE_ON_WALLS
    set_FLOW_BIAS(false)
    set_CATALASE_ON_WALLS(false)

    arlett_print()
    n_array = []
    innercrosstalk_array = []
    outercrosstalk_array = []
    center, inner, outer = (0, 0, 0)
    innercrosstalk = 0.0; outercrosstalk = 0.0
    # Record data between trials instead of only the end using run_sim!()
    for n in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr[n])
        steps_sofar = 0
        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = one_step!(peroxidexy)
            steps_sofar += 1
            if collision == "left outer sensor" || collision == "right outer sensor"
                outer += 1
            elseif collision == "left inner sensor" || collision == "right inner sensor"
                inner += 1
            elseif collision == "center sensor"
                center += 1
            end
        end
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
    println("Random seed:\t\t$seed")
    df = DataFrame(
        nth_trial = n_array,
        inner_crosstalk = innercrosstalk_array,
        outer_crosstalk = outercrosstalk_array
    )
    current_df(df)
    current_seed(seed)
    current_path("out/noflowdata/")
    set_FLOW_BIAS(init_FLOW_BIAS)
    set_CATALASE_ON_WALLS(init_CATALASE)
    return df
end
