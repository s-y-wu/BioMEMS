using Random
using DataFrames

# include("PARAMETERS_arlett.jl")
# include("locations_arlett.jl")
# include("flow_arlett.jl")
# include("spawn_arlett.jl")
# include(pwd() * "\\src\\walk_logic\\walk_logic.jl")
# include(pwd() * "\\src\\view_out\\data.jl")

function save_arlett_animation(seed::Int=randseed())
    df = arlett_animation(seed)
    folderpath = "\\out\\animations\\"
    savedata(df, folderpath)
    return nothing
end

function arlett_animation(seed::Int=randseed())::DataFrame
    Random.seed!(seed)
    x_arr = []
    y_arr = []
    peroxidexy = spawnrandompoint()
    index = 0
    every_tenth_frame = 10
    while peroxidexy != undef && index < MAX_STEPS_PER_WALK
        if index % every_tenth_frame == 0
            x, y = peroxidexy
            compressedX = convert(Float16, x)
            compressedY = convert(Float16, y)
            push!(x_arr, compressedX)
            push!(y_arr, compressedY)
        end
        peroxidexy, collisiontype = one_step!(peroxidexy)
        index += 1
    end
    df = DataFrame(x_coordinate = x_arr,
                    y_coordinate = y_arr)
    return df
end
