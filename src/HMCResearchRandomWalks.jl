module HMCResearchRandomWalks

module Arlett
using Random, DataFrames, CSV, DataFrames, Dates
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/arlett.jl"))
include(string(@__DIR__, "/view_out/data.jl"))
export arlett_sim,
    arlett_no_flow_data, save_arlett_noflow_data, arlett_animation, save_arlett_animation
end

end


# module ArlettBackend
#     using Reexport
#     @reexport using Arlett
#     export approach_wall!,
#            boundary_check, one_step!
#            north!, eastwest!, evaluate_proposed,
#            watercalc, enzcalc, ppdcalc,
#            insafebounds, inescapebounds,
#            run_sim!, randseed,
#
#            flow_arlett, getspeed
#
#            inwalls, inwater, inenz, inppd,
#            inoverflowenz, insensor,
#            incentersensorx, ininnersensorx, inoutersensorx,
#            sensorcases
#
#            spawnrandompoint, whereoutsidespawn
# end
#


#module ViewOut.jl
