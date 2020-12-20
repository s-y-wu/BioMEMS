using SafeTestsets

@time begin
    @time @safetestset "Arlett Experiment Tests" begin include("arlett_test.jl") end
end
