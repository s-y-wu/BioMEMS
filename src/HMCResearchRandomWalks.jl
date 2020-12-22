module HMCResearchRandomWalks

module Arlett
using Random, DataFrames, CSV, DataFrames, Dates
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/arlett.jl"))
include(string(@__DIR__, "/view_out/data.jl"))
export arlett_sim,
       arlett_no_flow_data,
       save_arlett_noflow_data,
       arlett_animation,
       save_arlett_animation,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_FLOW_BIAS,
       set_CATALASE_ON_WALLS
end

end



#module ViewOut.jl
