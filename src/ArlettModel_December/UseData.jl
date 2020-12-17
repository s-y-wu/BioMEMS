using CSV
using DataFrames
using Dates

function savedata(df::DataFrame, relativefolderpath::String="\\out\\", seedstring::String="no_seed")
    timestring = string(Dates.now())
    microsoftsafestring = replace(timeNow, ":" => ";")
    filename = microsoftsafestring * "_seed" * seedstring * ".csv"
    fullpath = pwd() * relativefolderpath * filename
    CSV.write(fullpath, df)
    println(filename, " save success!")
    return nothing
end

function getdata(filename::String, relativefolderpath::String="\\out\\")::DataFrame
    fullpath = pwd() * relativefolderpath * filename
    csvdata = CSV.File(fullpath)
    df = DataFrame(csvdata)
    return df
end
