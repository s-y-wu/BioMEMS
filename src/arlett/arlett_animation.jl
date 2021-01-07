"""
    getdata_arlett_animation([seed]) -> DataFrame

Start and finish one Arlett walk and return every tenth coordinate in a DataFrame.

Other simulation controls include:
    set_FLOW_BIAS()
    set_CATALASE_ON_WALLS()
"""
function getdata_arlett_animation(seed::Int=randseed())
    init_N = NUMBER_OF_WALKS
    set_NUMBER_OF_WALKS(1)
    arlett_print()
    println("Random seed:\t\t$seed")
    println("NOTE: # of steps (max) is ignored")
    Random.seed!(seed)
    x_arr, y_arr = ([], [])
    steps_sofar = 0
    every_tenth_frame = 10
    # Record every tenth xy position instead of run_sim!()
    peroxidexy = spawnrandompoint()
    while peroxidexy != undef
        if steps_sofar % every_tenth_frame == 0
            x, y = peroxidexy
            compressedX = convert(Float16, x)
            compressedY = convert(Float16, y)
            push!(x_arr, compressedX)
            push!(y_arr, compressedY)
        end
        peroxidexy, collisiontype = one_step!(peroxidexy)
        steps_sofar += 1
    end
    df = DataFrame(x_coordinate = x_arr,
                    y_coordinate = y_arr)
    current_df(df)
    current_seed(seed)
    current_path("out/animations/")
    set_NUMBER_OF_WALKS(init_N)
    return df
end
