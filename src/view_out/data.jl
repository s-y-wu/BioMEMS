include("current.jl")
"
    savedata

Write most recent dataframe into a CSV file.
"
function savedata(filename::AbstractString=nameCSVfile())
    df = current_df()
    fullpath = abspath(expanduser(joinpath("out", filename)))
    CSV.write(fullpath, df)
    current_path(fullpath)
    nothing
end

function mysavedata(paths::AbstractString...)
    df = current_df()
    fullpath = abspath(expanduser(joinpath(paths, nameCSVfile())))
    CSV.write(fullpath, df)
    current_path(fullpath)
    nothing
end

function nameCSVfile()
    rightnow = string(Dates.now())
    template = string(rightnow, "_seed_", current_seed())
    clean = replace(replace(fntemplate, ":" => "_"), "." => "_")
    fn = string(clean, ".csv")
    return fn
end


function getdata(filename::String, relativefolderpath::String="/out/")::DataFrame
    fullpath = pwd() * relativefolderpath * filename
    csvdata = CSV.File(fullpath)
    df = DataFrame(csvdata)
    return df
end
