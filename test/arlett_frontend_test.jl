using Test
using HMCResearchRandomWalks.Arlett

@testset "Setters for simulation controls" begin
    set_NUMBER_OF_WALKS()
    @test Arlett.NUMBER_OF_WALKS == 100
    set_NUMBER_OF_WALKS(10)
    @test Arlett.NUMBER_OF_WALKS == 10

    set_MAX_STEPS_PER_WALK()
    @test Arlett.MAX_STEPS_PER_WALK == 1485604
    set_MAX_STEPS_PER_WALK(2000000)
    @test Arlett.MAX_STEPS_PER_WALK == 2000000

    set_FLOW_BIAS()
    @test Arlett.FLOW_BIAS
    set_FLOW_BIAS(false)
    @test !Arlett.FLOW_BIAS
    set_FLOW_BIAS(true)
    @test Arlett.FLOW_BIAS

    set_CATALASE_ON_WALLS()
    @test Arlett.CATALASE_ON_WALLS
    set_CATALASE_ON_WALLS(false)
    @test !Arlett.CATALASE_ON_WALLS
    set_CATALASE_ON_WALLS(true)
    @test Arlett.CATALASE_ON_WALLS
end
