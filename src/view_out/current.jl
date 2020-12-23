# Adapted from Plots.jl
mutable struct Current
    nullable_df::Union{DataFrame, Nothing}
    nullable_seed::Union{AbstractString, Nothing}
    nullable_path::Union{AbstractString, Nothing}
end
const CURRENT = Current(nothing, nothing, nothing)
isdfnull() = CURRENT.nullable_df === nothing
isseednull() = CURRENT.nullable_seed === nothing
ispathnull() = CURRENT.nullable_path === nothing

function current_df()
    if isdfnull()
        error("No current animation/dataframe, run a walk first")
    end
    CURRENT.nullable_df
end
current_df(df::DataFrame) = (CURRENT.nullable_df = df)

function current_seed()
    if isseednull()
        error("No current seed, run a walk first.")
    end
    CURRENT.nullable_seed
end
current_seed(seed::Int) = (CURRENT.seed = string(seed))
current_seed(seed::AbstractString) = (CURRENT.nullable_seed = seed)

function current_path()
    if ispathnull()
        error("No current path, save a walk first.")
    end
    CURRENT.nullable_path
end
current_path(path::AbstractString) = (CURRENT.nullable_path = path)
