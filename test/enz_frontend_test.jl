using Test
using HMCResearchRandomWalks.Enz

@testset "Setter for simulation control" begin
    set_THICK_ENZ()
    @test Enz.THICK_ENZ == true
    set_THICK_ENZ(false)
    @test Enz.THICK_ENZ == false
    set_THICK_ENZ(true)
    @test Enz.THICK_ENZ == true
end
