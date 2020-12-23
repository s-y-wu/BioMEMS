"
    save_arlett_noflow_data

Save the most recent data into a CSV file in the /out/noflowdata folder.
Only use right after arlett_noflow_data().
"
function save_arlett_noflowdata()
    mysavedata("out", "noflowdata")
    nothing
end

"
    arlett_noflowdata([Int]) -> DataFrame

Disable flow bias, run the Arlett simulation, and revert controls.

For each walk that ends in a sensor collision, return
    1. the trial #
    2. inner sensor cross talk, average of left and right
    3. outer sensor cross talk, average of left and right
in a DataFrame.
"
function arlett_noflowdata(seed::Int=randseed())
    Random.seed!(seed)
    current_seed(seed)
    float_arr = rand(NUMBER_OF_WALKS)
    init_FLOW_BIAS = FLOW_BIAS
    set_FLOW_BIAS(false)

    n_array = []
    innercrosstalk_array = []
    outercrosstalk_array = []
    center = 0
    inner = 0
    outer = 0
    innercrosstalk = 0.0
    outercrosstalk = 0.0

    println("Begin No Flow Simulation. Seed: $seed")
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

    df = DataFrame(
        nth_trial = n_array,
        inner_crosstalk = innercrosstalk_array,
        outer_crosstalk = outercrosstalk_array)
    current_df(df)
    set_FLOW_BIAS(init_FLOW_BIAS)
    return df
end
