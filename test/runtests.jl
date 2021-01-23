using SafeTestsets

@time begin
    # Important: "Current Loaded Data" testset must be called first. It relies on initial null CURRENT
    @time @safetestset "Current Loaded Data" begin include("current_test.jl") end

    @time @safetestset "Save/Load Data" begin include("data_test.jl") end

    @time @safetestset "Walk Logic Tests (using Arlett)" begin include("arlett_walk_logic_test.jl") end

    @time @safetestset "Arlett Backend Tests" begin include("arlett_backend_test.jl") end
    @time @safetestset "Arlett Frontend Tests" begin include("arlett_frontend_test.jl") end

    @time @safetestset "Enz Backend Tests" begin include("enz_backend_test.jl") end
    @time @safetestset "Enz Frontend Tests" begin include("enz_frontend_test.jl") end

    @time @safetestset "PPD Backend Tests" begin include("ppd_backend_test.jl") end
    @time @safetestset "PPD Frontend Tests" begin include("ppd_frontend_test.jl") end

    @time @safetestset "Quinto Backend Tests" begin include("quinto_backend_test.jl") end
end
