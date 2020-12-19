using CSV
using DataFrames
using Dates

"
    savedata

Write DataFrame into a CSV file. Name the CSV file by time and an input seed of type String.
"
function savedata(df::DataFrame, relativefolderpath::String="out/", seedstring::String="no_seed")
    timestring = string(Dates.now())
    # Microsoft file names prohibit ":"
    microsoftsafestring = replace(timeNow, ":" => ";")
    filename = microsoftsafestring * "_seed" * seedstring * ".csv"
    fullpath = normpath(@__DIR__, "..", "..") * relativefolderpath * filename
    CSV.write(fullpath, df)
    println(filename, " save success!")
    return nothing
end

function getdata(filename::String, relativefolderpath::String="/out/")::DataFrame
    fullpath = pwd() * relativefolderpath * filename
    csvdata = CSV.File(fullpath)
    df = DataFrame(csvdata)
    return df
end
