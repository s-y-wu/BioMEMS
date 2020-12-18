using Random
using DataFrames

include("PARAMETERS_Arlett.jl")
include("Locations_Arlett.jl")
include("Flow_Arlett.jl")
include("Spawn_Arlett.jl")
include(pwd() * "\\src\\WalkLogic\\WalkLogic.jl")
include(pwd() * "\\src\\ViewOut\\UseData.jl")

function saveanimation_arlett(seed::Int=randseed())
    df = animatesimulation_arlett(seed)
    folderpath = "\\out\\animations\\"
    savedata(df, folderpath)
    return nothing
end

function animatesimulation_arlett(seed::Int=randseed())::DataFrame
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
        peroxidexy, collisiontype = onestep!(peroxidexy)
        index += 1
    end
    df = DataFrame(x_coordinate = x_arr,
                    y_coordinate = y_arr)
    return df
end
