# Author: Sean Wu
# First Written: December 15

using DataFrames
"Lab data shows no ppd has double the yield of ppd"

include("PPD_PARAMETERS.jl")
include("PPD_LOCATIONS.jl")
include("BoundaryCross.jl")
include("BoundaryCheck.jl")
include("CalcProposed.jl")
include("Flow.jl")
include("OneStep.jl")
include("Collision.jl")

function getPPDStep()
    for ss in ppdSStoTest
        append!(ss_arr, ss)
        global ppdStepSize = ss
        global stepSizeDict = Dict("water" => waterStepSize, "enz" => ss, "ppd" => 0)
        data = callSimulation()
        append!(sensor_arr, data["sensor"])
        append!(escape_arr, data["escape"])
        append!(unresv_arr, data["particles unresolved"])
    end
end

function runData()
    println("PPD Stepsize Derivation")
    println("PPD?: $PPD_ON")
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

# begin
#     println("Compare PPD Step Sizes")
#     println("PPD?: $PPD_ON")
#     if PPD_ON
#         const ppdSStoTest = [0.007]
#     else
#         const ppdSStoTest = [waterStepSize]
#     end
#     ss_arr = []
#     sensor_arr = []
#     escape_arr = []
#     unresv_arr = []
#     # thin enzyme layer, 0.2 microns thick
#     getPPDStep()
#     netyield_arr = [sensor_arr[i] / (NUMBER_OF_WALKS - unresv_arr[i]) for i in 1:length(sensor_arr)]
#
#     df = DataFrame(step_size = ss_arr,
#         sensor_yield = sensor_arr,
#         escaped = escape_arr,
#         unresolved = unresv_arr,
#         net_yield = netyield_arr)
# end
