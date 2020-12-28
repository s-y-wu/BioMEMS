using Test, HMCResearchRandomWalks.PPD

@testset "setters for simulation control" begin
    set_PPD_ON(true)
    @test PPD.PPD_ON
    @test PPD.PPD_STEP_SIZE == 0.001
    @test PPD.STEP_SIZE_DICT["ppd"] == 0.001

    set_PPD_ON(false)
    @test !PPD.PPD_ON
    @test PPD.PPD_STEP_SIZE == 0.1
    @test PPD.STEP_SIZE_DICT["ppd"] == 0.1
end
