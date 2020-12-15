using DataFrames
"Lab data shows thin enzyme has ~ double the yield of thick enzyme"

include("ENZ_PARAMETERS.jl")
include("ENZ_LOCATIONS.jl")
include("BoundaryCross.jl")
include("BoundaryCheck.jl")
include("CalcProposed.jl")
include("Flow.jl")
include("Spawn.jl")             #spawnRandomPoint, whereOutsideSpawn
include("OneStep.jl")           #inSafeBounds, inEscapeBounds
include("Collision.jl")         #sensWall

function getEnzStep()
    for ss in enzSStoTest
        append!(ss_arr, ss)
        append!(thick_arr, enzymeMaxY)
        global enzStepSize = ss
        global stepSizeDict = Dict("water" => waterStepSize, "enz" => ss, "ppd" => 0)
        data = callSimulation()
        append!(sensor_arr, data["sensor"])
        append!(escape_arr, data["escape"])
        append!(unresv_arr, data["particles unresolved"])
    end
end

function runData(seed::Int64)
    Random.seed!(eed)
    runData()
end

function runData()
    println("Enzyme Stepsize Derivation")
    println("Enzyme Thickness:\t$enzymeMaxY")
    println("Particles: $NUMBER_OF_WALKS \t Steps: $MAX_STEPS_PER_WALK\t Step lengths: $stepSizeDict")
    output = callSimulation()

    presentationOrder = ["sensor",
        "escape",
        "particles unresolved",
        "avg steps taken"]

    for key in presentationOrder
        println(key, "\t", output[key])
    end
end

function callSimulation()
    data = Dict{String,Integer}()
    data["sensor"] = 0
    data["escape"] = 0
    data["particles unresolved"] = 0
    output = runSimulation(data)
    return output
end

begin
    println("Compare Enzymatic Step Sizes")
    println("Thick Enzyme? (thin == false) $THICK_ENZ")
    const enzSStoTest = [0.05, 0.005]
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
