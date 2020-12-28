using Test
using HMCResearchRandomWalks.Enz

"testing functions for locations"
function rand_x() return Enz.ESCAPE_X * rand() * 2 - Enz.ESCAPE_X end
function rand_y() return Enz.ESCAPE_Y * rand() end # greater than 0.0

@testset "constant locations" begin
    @test Enz.inwater([rand_x(), 5.0])
    @test Enz.inwater([rand_x(), 149.0])

    @test Enz.insensor([0.0, -0.001])
    @test Enz.insensor([140.0, -0.001])
    @test Enz.insensor([-140.0, -0.001])
    @test !Enz.insensor([140.1, -0.001])
    @test !Enz.insensor([-140.1, -0.001])
    @test !Enz.insensor([rand_x(), 0.001])

    @test Enz.inwalls(140.1, -0.001)
    @test Enz.inwalls(-140.1, -0.001)
    @test Enz.inwalls(280.0, -0.001)
    @test Enz.inwalls(-280.0, -0.001)
    @test !Enz.inwalls(rand_x(), rand_y())

    @test !Enz.inppd([rand_x(), rand_y()])
end

@testset "thick/thin locations" begin
    Enz.set_THICK_ENZ(true)
    @test Enz.inenz([0.0, 1.5])
    @test !Enz.inwater([0.0, 1.5])

    Enz.set_THICK_ENZ(false)
    @test !Enz.inenz([0.0, 1.5])
    @test Enz.inwater([0.0, 1.5])
    @test Enz.inenz([0.0, 0.15])
    @test !Enz.inwater([0.0, 0.15])
end

@testset "boundarycheck cases" begin
    @test Enz.sensorcases(rand_x()) == "sensor"

    initxy = [150.0, 0.003]
    dx = 0.0
    dy = -1.0
    ss = 0.005
    output = Enz.wallcases(initxy, dx, dy, ss)
    @test output[1] == [150.0, 0.0005]
    @test output[2] == "no collision"
end
