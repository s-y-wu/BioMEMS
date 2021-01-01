# Adapted from Plots.jl
mutable struct Current
    nullable_df::Union{DataFrame, Nothing}
    nullable_seed::Union{AbstractString, Nothing}
    nullable_path::Union{AbstractString, Nothing}
    nullable_file::Union{AbstractString, Nothing}
end
const CURRENT = Current(nothing, nothing, nothing, nothing)
isdfnull() = CURRENT.nullable_df === nothing
isseednull() = CURRENT.nullable_seed === nothing
ispathnull() = CURRENT.nullable_path === nothing
isfilenull() = CURRENT.nullable_file === nothing

function current_df()
    if isdfnull()
        @warn("No DataFrame loaded. Run the getdata_...(...) method first.")
    end
    CURRENT.nullable_df
end
current_df(df::DataFrame) = (CURRENT.nullable_df = df)

function current_seed()
    if isseednull()
        @warn("No seed loaded. Run the getdata_...(...[,seed]) method first.")
    end
    CURRENT.nullable_seed
end
current_seed(seed::AbstractString) = (CURRENT.nullable_seed = seed)
current_seed(seed::Int) = current_seed(string(seed))

function current_path()
    if ispathnull()
        @warn("No path loaded. Run the getdata_...(...) method first")
    end
    CURRENT.nullable_path
end
current_path(path::AbstractString) = (CURRENT.nullable_path = path)

function current_file()
    if isfilenull()
        @warn("No file loaded. Run savedata() or savetofolder() first.")
    end
    CURRENT.nullable_file
end
current_file(fullfilepath::AbstractString) = (CURRENT.nullable_file = fullfilepath)
