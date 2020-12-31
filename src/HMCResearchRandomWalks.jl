module HMCResearchRandomWalks

module Enz
using Random, DataFrames, CSV, Dates
include(string(@__DIR__, "/step_size/PARAMETERS_enz.jl"))
include(string(@__DIR__, "/step_size/locations_enz.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/flow_arlett.jl"))
include(string(@__DIR__, "/arlett/spawn_arlett.jl"))
include(string(@__DIR__, "/step_size/enz_sim.jl"))
# include(pwd() * "/src/view_out/data.jl")
export enz_sim,
       find_enzstepsize,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_THICK_ENZ,
       set_ENZ_STEP_SIZE
end


module PPD
using Random, DataFrames, CSV, Dates
include(string(@__DIR__, "/step_size/PARAMETERS_ppd.jl"))
include(string(@__DIR__, "/step_size/locations_ppd.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/flow_arlett.jl"))
include(string(@__DIR__, "/step_size/ppd_sim.jl"))
# include(pwd() * "/src/view_out/data.jl")
export ppd_sim,
       find_ppdstepsize,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_PPD_ON,
       set_PPD_STEP_SIZE
end


module Arlett
using Random, DataFrames, CSV, Dates
include(string(@__DIR__, "/arlett/arlett.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/view_out/data.jl"))
export arlett_sim,
       arlett_noflowdata,
       save_arlett_noflowdata,
       arlett_animation,
       save_arlett_animation,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_FLOW_BIAS,
       set_CATALASE_ON_WALLS
end

module ViewOut
using DataFrames, CSV, Dates
include(string(@__DIR__, "/view_out/data.jl"))
include(string(@__DIR__, "/view_out/plot_noflow.jl"))
export plotdata_noflow,
       savedata,
       getdata
end

end
