"
    getdata_quinto([Int]) -> DataFrame


For each walk that ends in a sensor collision, return
    1. the trial #
    2. second sensor cross talk
    3. third sensor cross talk
    4. fourth sensor cross talk
in a DataFrame.
Simulation controls:
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
"
function getdata_quinto(seed::Int=randseed())
    Random.seed!(seed)
    float_arr = rand(NUMBER_OF_WALKS)
    stub_arr = rand(NUMBER_OF_WALKS) # for consistency with run_sim!()

    quinto_print(seed)
    n_array = []
    second_ctalk_array = []; third_ctalk_array = []; fourth_ctalk_array = []
    spawn, second, third, fourth = (0, 0, 0, 0)
    second_ctalk = 0.0; third_ctalk = 0.0; fourth_ctalk = 0.0
    # Record data between trials instead of only the end using run_sim!()
    @showprogress for n in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr[n])
        steps_sofar = 0
        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = one_step!(peroxidexy)
            steps_sofar += 1
            if collision == "spawn sensor"
                spawn += 1
            elseif collision == "second sensor"
                second += 1
            elseif collision == "third sensor"
                third += 1
            elseif collision == "fourth sensor"
                fourth += 1
            end
        end
        if spawn > 0
            second_ctalk = 100.0 * second / spawn
            third_ctalk = 100.0 * third / spawn
            fourth_ctalk = 100.0 * fourth / spawn
        else
            if second > 0
                second_ctalk = 100.0
            elseif third > 0
                third_ctalk = 100.0
            elseif fourth > 0
                fourth_ctalk = 100.0
            end
        end
        append!(n_array, n)
        append!(second_ctalk_array, second_ctalk)
        append!(third_ctalk_array, third_ctalk)
        append!(fourth_ctalk_array, fourth_ctalk)
    end
    df = DataFrame(
        nth_trial = n_array,
        second_crosstalk = second_ctalk_array,
        third_crosstalk = third_ctalk_array,
        fourth_crosstalk = fourth_ctalk_array
    )
    current_df(df)
    current_seed(seed)
    current_path("out/quintodata/")
    return df
end
