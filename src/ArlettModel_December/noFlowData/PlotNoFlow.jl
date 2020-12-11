using CSV
using DataFrames
using Plots

function inputFileName(relativepath::String)
    path = "C://Users//sywu//.julia//dev//HMCResearchRandomWalks//src//ArlettModel_December//noFlowData//"
    fullname = path * relativepath
    plotData(fullname)
end

function plotData(pathname::String)
    csv_data = CSV.File(pathname)
    df = DataFrame(csv_data)

    x_data = df[:, "nth_trial"]
    y_data = df[:, "innerXtalk"]

    # x-axis upper boundL round up to the hundredth
    roundBy = 100
    x_max = roundBy * div(last(x_data), roundBy, RoundUp)

    Plots.plot(x_data, y_data,
        gridalpha = 0, # hide grey grid lines
        label = "", # no legend entry
        title = "figure caption will explain inner sensor",
        xlims = (0.0, x_max),
        ylims = (0.0, 100.0) )
    xlabel!("number of trials")
    ylabel!("cross talk %")
end
