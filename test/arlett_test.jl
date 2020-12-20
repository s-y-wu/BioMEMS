using Test
using HMCResearchRandomWalks.Arlett

@testset "Nontrivial PARAMETERS_arlett.jl" begin
    @test isapprox(Arlett.SENSOR_CENTER_MAX_X, 12.5)
    @test isapprox(Arlett.SENSOR_INNER_ADJ_MIN_X, 32.5)
    @test isapprox(Arlett.SENSOR_INNER_ADJ_MAX_X, 57.5)
    @test isapprox(Arlett.SENSOR_OUTER_ADJ_MIN_X, 77.5)
    @test isapprox(Arlett.SENSOR_OUTER_ADJ_MAX_X, 102.5)
    @test isapprox(Arlett.ENZYME_MAX_Y, 1.65)
    @test isapprox(Arlett.SPAWN_LEFT_X, -13.499)
    @test isapprox(Arlett.SPAWN_RIGHT_X, 13.499)
    @test isapprox(Arlett.SPAWN_ENZYME_MAX_Y, 1.649)
    @test isapprox(Arlett.MARGIN_OF_COLLISION, 0.2)
    @test isapprox(Arlett.ESCAPE_X, 122.5)
    @test isapprox(Arlett.ESCAPE_Y, 122.5)
    @test isapprox(Arlett.SAFE_MIN_Y, 1.85)
    @test isapprox(Arlett.SAFE_MAX_Y, 122.3)
    @test isapprox(Arlett.SAFE_MAX_X, 122.3)
    #TODO: Enzyme-Water Corners
end

@testset "spawnrandompoint() in Arlett" begin
    leftwallspawn = Arlett.spawnrandompoint(0.0)
    @test isapprox(leftwallspawn[1], -13.499)
    @test isapprox(leftwallspawn[2], 1.501)

    leftcornerspawn = Arlett.spawnrandompoint(0.149/27.296)
    @test isapprox(leftcornerspawn[1], -13.499)
    @test isapprox(leftcornerspawn[2], 1.649)

    rightwallspawn = Arlett.spawnrandompoint(1.0)
    @test isapprox(rightwallspawn[1], 13.499)
    @test isapprox(rightwallspawn[2], 1.501)

    rightcornerspawn = Arlett.spawnrandompoint(27.147/27.296)
    @test isapprox(rightcornerspawn[1], 13.499)
    @test isapprox(leftcornerspawn[2], 1.649)

    centerspawn = Arlett.spawnrandompoint(0.5)
    @test isapprox(centerspawn[1], 0)
    @test isapprox(centerspawn[2], 1.649)

    @test Arlett.inenz(leftwallspawn)
    @test Arlett.inenz(leftcornerspawn)
    @test Arlett.inenz(rightcornerspawn)
    @test Arlett.inenz(rightwallspawn)
    @test Arlett.inenz(centerspawn)
    @test !Arlett.inwalls(leftwallspawn[1], leftwallspawn[2])
    @test !Arlett.inwalls(rightwallspawn[1], rightwallspawn[2])
end

@testset "whereoutsidespawn in Arlett" begin
    @test Arlett.whereoutsidespawn([-14, 1.6]) == "W"
    @test Arlett.whereoutsidespawn([-14, 1.7]) == "NW"
    @test Arlett.whereoutsidespawn([0, 1.7]) == "N"
    @test Arlett.whereoutsidespawn([14, 1.7]) == "NE"
    @test Arlett.whereoutsidespawn([14, 1.6]) == "E"
    @test Arlett.whereoutsidespawn([0, 1.6]) == "whereoutsidespawn Error"
end
