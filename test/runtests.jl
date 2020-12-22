using SafeTestsets

@time begin
    @time @safetestset "Arlett Backend Tests" begin include("arlett_backend_test.jl") end
    @time @safetestset "Arlett Walk Logic Tests" begin include("arlett_walk_logic_test.jl") end
    @time @safetestset "Arlett Frontend Tests" begin include("arlett_frontend_test.jl") end
end
