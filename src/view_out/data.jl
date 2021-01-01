const working_dir_path = normpath(@__DIR__, "..","..")
"""
    savetofolder() -> fullpath::String

Save the most recent DataFrame into a new CSV. File into the corresponding folder of the
.../HMCResearchRandomWalks/out/... directory.

Name the file using the most recent seed and time when savetofolder() is called.
"""
function savetofolder()
    df = current_df()
    folderpath = current_path()
    fn = nameCSVfile()
    fullpath = abspath(string(working_dir_path, folderpath, fn))
    return savehelper(fullpath, df)
end

"""
    savedata([filename, df]) -> fullpath::String

Save a DataFrame into a new CSV file labelled by file name. File will be found in .../HMCResearchRandomWalks/out

If no filename is given, name the file using the most recent seed and time when savedata() is called.
If no df is given, save the most recent DataFrame loaded by the last getdata_...() call in this terminal.
"""
function savedata(filename::AbstractString=nameCSVfile(), df::DataFrame=current_df())
    fullpath = abspath(string(working_dir_path, "out/", filename))
    return savehelper(fullpath, df)
end

"""
    loaddata([path, relative])

Load a CSV file in .../HMCResearchRandomWalks/out as a DataFrame.

If no path is given, load the most recent CSV file saved by savedata() or savetofolder()
By default relative=false, so the given path must begin from the user system.
If relative=true, the given path must begin with "out/..." or "/out/..."
"""
function loaddata(path::AbstractString=current_file(), relative::Bool=false)::DataFrame
    if relative
        fullpath = abspath(string(working_dir_path, path))
    else
        fullpath = path
    end

    if !isfile(fullpath)
        @warn("No such file found. Please double check the path.")
    else
        csvdata = CSV.File(fullpath)
        df = DataFrame(csvdata)
        return df
    end
end

"Helper function to write the CSV file and checks for a valid file name"
function savehelper(fullpath::AbstractString, df::DataFrame)
    _, ext = splitext(fullpath)
    if ext != ".csv"
        @warn("File name must end with the .csv extension")
    else
        CSV.write(fullpath, df)
        current_file(fullpath)
        println("CSV File saved at the given path:")
        println(fullpath)
        return fullpath
    end
end

"Helper function to name using time and the seed loaded in CURRENT"
function nameCSVfile()
    rightnow = string(Dates.now())
    fntemplate = string(rightnow, "_seed_", current_seed())
    clean = replace(replace(fntemplate, ":" => "_"), "." => "_")
    fn = string(clean, ".csv")
    return fn
end
