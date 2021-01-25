function plotdata_noflow(filename::String=current_file())
    df = loaddata(filename)

    x_data = df[:, "nth_trial"]
    y_data = [  df[:, "right_inner_crosstalk"],
                df[:, "right_outer_crosstalk"],
                df[:, "left_inner_crosstalk"],
                df[:, "left_outer_crosstalk"],
                 ]

    # x-axis upper boundL round up to the hundredth
    roundBy = 100
    x_max = roundBy * div(last(x_data), roundBy, RoundUp)
    Plots.plot(x_data, y_data,
        palette = :seaborn_bright,
        gridalpha = 0, # hide grey grid lines
        label = ["right inner sensor" "right outer sensor"  "left inner sensor" "left outer sensor"],
        title = "Arlett Simulation w/ No Flow",
        xlims = (0.0, x_max),
        ylims = (0.0, 100.0) )
    xlabel!("number of trials")
    ylabel!("cross talk %")
end

"plot seed_6009.csv for enz step size"
function plot_enz()
    enzss_x = [0.001, 0.005, 0.01, 0.02, 0.025]
    enzss_thick_y = [101, 430, 607, 751, 784]
    enzss_thin_y = [600, 846, 874, 907, 906]
    thin_over_thick = [enzss_thin_y[i] / enzss_thick_y[i] for i in 1:5 ]
    Plots.scatter(enzss_x, thin_over_thick,
        gridalpha = 0, # hide grey grid lines
        label = "", # no legend entry
        title = "Enzymatic Layer Step Size Derivation",
        xlims = (0.0, 0.0255),
        ylims = (0.0, 6) )
    xlabel!("Step Size in Enzymatic Layer [um]")
    ylabel!("Thin/Thick Sensor Yield Ratio")
end


function plot_ppd()
    ppdss_x = [0.0005, 0.001, 0.002, 0.003, 0.004, 0.005]
    ppd_yield = [300, 460, 608, 689, 747, 783, 951]
    ppd_y = [951 / ppd_yield[i] for i in 1:6]
    Plots.scatter(ppdss_x, ppd_y,
        gridalpha = 0, # hide grey grid lines
        label = "", # no legend entry
        title = "PPD Layer Step Size Derivation",
        xlims = (0.0, 0.011),
        ylims = (0.0, 3) )
    xlabel!("Step Size in Enzymatic Layer [um]")
    ylabel!("(No PPD)/(With PPD) Sensor Yield Ratio")
end

function plot_quinto()
    df = loaddata(filename)
    x_data = df[:, "nth_trial"]
    y_data = [  df[:, "second_crosstalk"],
                df[:, "third_crosstalk"],
                df[:, "fourth_crosstalk"] ]

    # x-axis upper boundL round up to the hundredth
    roundBy = 100
    x_max = roundBy * div(last(x_data), roundBy, RoundUp)

    Plots.plot(x_data, y_data,
        gridalpha = 0, # hide grey grid lines
        label = ["second sensor", "third sensor", "fourth sensor"],
        title = "Quinto Simulation",
        xlims = (0.0, x_max),
        ylims = (0.0, 100.0) )
    xlabel!("number of trials")
    ylabel!("cross talk %")
end

function plot_arlett_flow()
    df = loaddata(current_file())

    x_data = df[:, "nth_trial"]
    y_data = [  df[:, "right_inner_crosstalk"],
                df[:, "right_outer_crosstalk"],
                df[:, "left_inner_crosstalk"],
                df[:, "left_outer_crosstalk"],
                 ]

    # x-axis upper boundL round up to the hundredth
    roundBy = 100
    x_max = roundBy * div(last(x_data), roundBy, RoundUp)
    Plots.plot(x_data, y_data,
        palette = :seaborn_bright,
        gridalpha = 0, # hide grey grid lines
        label = ["right inner sensor (downstream)" "right outer sensor (downstream)"  "left inner sensor (upstream)" "left outer sensor (upstream)"],
        title = "Arlett Simulation w/ Flow",
        xlims = (0.0, x_max),
        ylims = (0.0, 100.0) )
    xlabel!("number of trials")
    ylabel!("cross talk %")
end

function plotdata_noflow(filename::String=current_file())
    df = loaddata(filename)

    x_data = df[:, "nth_trial"]
    y_data = [  df[:, "right_inner_crosstalk"],
                df[:, "right_outer_crosstalk"],
                df[:, "left_inner_crosstalk"],
                df[:, "left_outer_crosstalk"],
                 ]

    # x-axis upper boundL round up to the hundredth
    roundBy = 100
    x_max = roundBy * div(last(x_data), roundBy, RoundUp)
    Plots.plot(x_data, y_data,
        palette = :seaborn_bright,
        gridalpha = 0, # hide grey grid lines
        label = ["right inner sensor" "right outer sensor"  "left inner sensor" "left outer sensor"],
        title = "Arlett Simulation w/ Wall Catalase & No Flow",
        xlims = (0.0, x_max),
        ylims = (0.0, 100.0) )
    xlabel!("number of trials")
    ylabel!("cross talk %")
end


df = loaddata(current_file())

x_data = df[:, "nth_trial"]
y_data = [  df[:, "right_inner_crosstalk"],
            df[:, "right_outer_crosstalk"],
            df[:, "left_inner_crosstalk"],
            df[:, "left_outer_crosstalk"],
             ]

# x-axis upper boundL round up to the hundredth
roundBy = 100
x_max = roundBy * div(last(x_data), roundBy, RoundUp)
Plots.plot(x_data, y_data,
    palette = :seaborn_bright,
    gridalpha = 0, # hide grey grid lines
    label = ["right inner sensor" "right outer sensor"  "left inner sensor" "left outer sensor"],
    title = "Arlett Simulation w/ Wall Catalase & No Flow",
    xlims = (0.0, x_max),
    ylims = (0.0, 100.0) )
xlabel!("number of trials")
ylabel!("cross talk %")
