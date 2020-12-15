using HMCResearch2020RandomWalks
using Test

@testset "HMCResearch2020.jl" begin
    # Write your tests here.
end

@testset "Spawn.jl" begin
    @test spawnRandomPoint(0) == [-13.5, 1.5]
    @test spawnRandomPoint(1) == [13.5, 1.5]
end
