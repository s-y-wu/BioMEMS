using DataFrames

"Lab data shows thin enzyme has ~ double the yield of thick enzyme"
include("PARAMETERS_enz.jl")
include("locations_enz.jl")
include(pwd() * "/src/arlett/flow_arlett.jl")
include(pwd() * "/src/arlett/spawn_arlett.jl")
include(pwd() * "/src/walk_logic/walk_logic.jl")
# include(pwd() * "/src/view_out/data.jl")

function enz_sim(seed::Int=randseed())
    println("Enzyme Stepsize Derivation")
    println("Enzyme Thickness:\t$ENZYME_MAX_Y")
    println("Particles: $NUMBER_OF_WALKS \t Steps: $MAX_STEPS_PER_WALK\t Step lengths: $STEP_SIZE_DICT")
    data = Dict{String,Integer}()
    data["sensor"] = 0
    data["escape"] = 0
    data["particles unresolved"] = 0
    output = run_sim!(data, seed)

    presentationorder = ["sensor",
        "escape",
        "particles unresolved",
        "avg steps taken"]

    for key in presentationorder
        println(key, "\t", output[key])
    end
    return nothing
end

function getEnzStep()
    for ss in enzSStoTest
        append!(ss_arr, ss)
        append!(thick_arr, ENZYME_MAX_Y)
        global ENZ_STEP_SIZE = ss
        global STEP_SIZE_DICT = Dict("water" => WATER_STEP_SIZE, "enz" => ss, "ppd" => 0)
        data = callSimulation()
        append!(sensor_arr, data["sensor"])
        append!(escape_arr, data["escape"])
        append!(unresv_arr, data["particles unresolved"])
    end
    return nothing
end

begin
    println("Compare Enzymatic Step Sizes")
    println("Thick Enzyme? (thin == false) $THICK_ENZ")
    const enzSStoTest = [0.0045]
    ss_arr = []
    thick_arr = []
    sensor_arr = []
    escape_arr = []
    unresv_arr = []
    # thin enzyme layer, 0.2 microns thick
    getEnzStep()
    netyield_arr = [sensor_arr[i] / (NUMBER_OF_WALKS - unresv_arr[i]) for i in 1:length(sensor_arr)]

    df = DataFrame(step_size = ss_arr,
        enzyme_thickness = thick_arr,
        sensor_yield = sensor_arr,
        escaped = escape_arr,
        unresolved = unresv_arr,
        net_yield = netyield_arr)
end
