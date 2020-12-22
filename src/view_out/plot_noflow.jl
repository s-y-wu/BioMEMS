const defaultfile = "2020-12-10T22;02;09.626_seed1234.csv"

function plotdata_noflow(filename::String=defaultfile)
    df = getdata(filename, "/out/noFlowData/")

    x_data = df[:, "nth_trial"]
    y_data = df[:, "inner_crosstalk"]

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
