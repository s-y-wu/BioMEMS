using Test, HMCResearchRandomWalks.PPD

"testing functions for locations"
function rand_x() return PPD.ESCAPE_X * rand() * 2 - PPD.ESCAPE_X end
function rand_y() return PPD.ESCAPE_Y * rand() end # greater than 0.0

@testset "new spawnrandompoint" begin
    for _ in 1:10
        initxy = PPD.spawnrandompoint()
        @test -12.0 <= initxy[1] <= 12.0
        @test 0.2 <= initxy[2] <= 1.0
    end
end

@testset "locations" begin
    @test PPD.insensor([rand_x(), 0.0])
    @test !PPD.insensor([rand_x(), 0.1])

    @test PPD.inwalls(13.0, 1.499)
    @test !PPD.inwalls(13.0, 1.501)
    @test !PPD.inwalls(12.0, 1.5)

    @test PPD.inppd([0.0, 0.15])
    @test !PPD.inppd([0.0, 0.16])
    @test !PPD.inppd([12.6, 0.15])

    @test PPD.inwater([0.0, 0.16])
    @test !PPD.inwater([13.0, 1.499])
    @test !PPD.inwater([0.0, 0.15])

    randxy = [rand_x(), rand_y()]
    @test !PPD.inenz(randxy)
    @test PPD.whereoutsidespawn([rand_x(), rand_y()]) == "N"
    @test PPD.sensorcases(randxy) == "sensor"
end

@testset "boundarycheck cases" begin
    initxy = [15.0, 1.56]
    dx = 0.0
    dy = -1.0
    ss = 0.1
    output = PPD.wallcases(initxy, dx, dy, ss)
    @test output[1] == [15.0, 1.51]
    @test output[2] == "no collision"
end
