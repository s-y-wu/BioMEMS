module HMCResearchRandomWalks

module ViewOut
using DataFrames, CSV, Dates
include(string(@__DIR__, "/view_out/current.jl"))
include(string(@__DIR__, "/view_out/data.jl"))
include(string(@__DIR__, "/view_out/plot_noflow.jl"))
export plotdata_noflow,
       savedata,
       savetofolder,
       loaddata,
       Current, current_df, current_seed, current_path, current_file
end

module Enz
using Random, DataFrames, Reexport, ProgressMeter
@reexport using HMCResearchRandomWalks.ViewOut
include(string(@__DIR__, "/step_size/PARAMETERS_enz.jl"))
include(string(@__DIR__, "/step_size/locations_enz.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/flow_arlett.jl"))
include(string(@__DIR__, "/arlett/spawn_arlett.jl"))
include(string(@__DIR__, "/step_size/enz_sim.jl"))
export enz_sim,
       getdata_enzstepsize,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_THICK_ENZ,
       set_ENZ_STEP_SIZE
end


module PPD
using Random, DataFrames, Reexport, ProgressMeter
@reexport using HMCResearchRandomWalks.ViewOut
include(string(@__DIR__, "/step_size/PARAMETERS_ppd.jl"))
include(string(@__DIR__, "/step_size/locations_ppd.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
include(string(@__DIR__, "/arlett/flow_arlett.jl"))
include(string(@__DIR__, "/step_size/ppd_sim.jl"))
export ppd_sim,
       getdata_ppdstepsize,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_PPD_ON,
       set_PPD_STEP_SIZE
end


module Arlett
using Random, DataFrames, Reexport, ProgressMeter
@reexport using HMCResearchRandomWalks.ViewOut
include(string(@__DIR__, "/arlett/arlett.jl"))
include(string(@__DIR__, "/walk_logic/walk_logic.jl"))
export arlett_sim,
       getdata_arlett_animation,
       getdata_arlett_noflow,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK,
       set_FLOW_BIAS,
       set_CATALASE_ON_WALLS
end


module Quinto
using Random, DataFrames, Reexport, ProgressMeter
@reexport using HMCResearchRandomWalks.ViewOut
include(string(@__DIR__, "/quinto/quinto_sim.jl"))
export quinto_sim,
       set_NUMBER_OF_WALKS,
       set_MAX_STEPS_PER_WALK
end


end
