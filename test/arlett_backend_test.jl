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

    randspawn = Arlett.spawnrandompoint()
    @test Arlett.inenz(randspawn)
    @test !Arlett.inwalls(randspawn[1], randspawn[2])
    @test isapprox(abs(randspawn[1]), 13.499) || isapprox(randspawn[2], 1.649)
end

@testset "whereoutsidespawn in Arlett" begin
    @test Arlett.whereoutsidespawn([-14, 1.6]) == "W"
    @test Arlett.whereoutsidespawn([-14, 1.7]) == "NW"
    @test Arlett.whereoutsidespawn([0, 1.7]) == "N"
    @test Arlett.whereoutsidespawn([14, 1.7]) == "NE"
    @test Arlett.whereoutsidespawn([14, 1.6]) == "E"
    @test Arlett.whereoutsidespawn([0, 1.6]) == "whereoutsidespawn Error"
end

"testing functions for locations"
function rand_x() return Arlett.ESCAPE_X * rand() * 2 - Arlett.ESCAPE_X end
function rand_y() return Arlett.ESCAPE_Y * rand() - 0.5 * Arlett.ESCAPE_Y end

@testset "flow_arlett.jl" begin
    set_FLOW_BIAS(true)
    coordinates_without_flow = [
        [-90, 0.1], [-45, 0.1], [0, 0.1], [45, 0.1], [90, 0.1], # in well, in ppd layer
        [-90, 1.4], [-45, 1.4], [45, 1.4], [90, 1.4],           # in well, in water
        [0, 1.4], [0, 1.6]                                      # in well, in enzymatic layer
    ]
    for coordinate in coordinates_without_flow
        @test Arlett.flow_arlett(coordinate) == 0
    end
    y_vals = [
        1.7,
        5,
        25,
        50,
        100
    ]
    correct_flow = [
        4.58262333 * 10^-5
        1.34607810 * 10^-4
        6.67729077 * 10^-4
        1.32218322 * 10^-3
        2.59126672 * 10^-3
    ]
    correct_speed = [
        16.92441308
        49.71297043
        246.60378821
        488.30491661
        956.999193998
    ]
    for i in 1:5
        x = rand_x() # flow is x invariant
        @test isapprox(Arlett.flow_arlett([x, y_vals[i]]), correct_flow[i])
        @test isapprox(Arlett.getspeed(y_vals[i]), correct_speed[i])
    end
end

@testset "locations_arlett.jl" begin
    @test !Arlett.inwalls(rand_x(), 1.51)

    @test Arlett.inwater([rand_x(), 1.66])
    @test !Arlett.inwater([0.0, 1.65])

    @test Arlett.inenz([0.0, 0.151])
    @test Arlett.inenz([0.0, 1.65])
    @test Arlett.inenz([-13.4, 1.6])

    @test !Arlett.inoverflowenz(1.0, 0.15)
    @test !Arlett.inoverflowenz(1.0, 1.5)
    @test Arlett.inoverflowenz(1.0, 1.6)
    @test Arlett.inoverflowenz(13.4, 1.6)
    @test !Arlett.inoverflowenz(1.0, 1.66)
    @test !Arlett.inoverflowenz(-13.6, 1.6)

    @test Arlett.incentersensorx(12.49*rand())
    @test Arlett.ininnersensorx(12.49*rand() + 32.5)
    @test Arlett.ininnersensorx(12.49*rand() - 57.5)
    @test Arlett.inoutersensorx(12.49*rand() + 77.5)
    @test Arlett.inoutersensorx(12.49*rand() - 102.5)

    @test Arlett.insensor([rand_x(), -1.0])
    @test Arlett.insensor([rand_x(), 0.0])
    @test !Arlett.insensor([rand_x(), 0.1])

    for x in [-90.0, -45.0, 0.0, 45.0, 90.0]
        @test !Arlett.inwalls(x, rand_y())
        @test Arlett.inwalls(x + 14, 1.5)
        @test !Arlett.inwalls(x + 14, 1.51)

        if x != 0.0
            @test Arlett.inwater([x, 0.151])
            @test Arlett.inwater([x, 1.65])
            @test !Arlett.inenz([x, 0.151])
            @test !Arlett.inenz([x, 1.65])
        end
        @test !Arlett.inwater([x, 0.15])
        @test Arlett.inppd([x, 0.15])
        @test !Arlett.inppd([x, 0.151])
    end
end

@testset "sensorcases() in locations_arlett.jl" begin
    @test Arlett.sensorcases(-90.0) == "left outer sensor"
    @test Arlett.sensorcases(-45.0) == "left inner sensor"
    @test Arlett.sensorcases(0.0) == "center sensor"
    @test Arlett.sensorcases(45.0) == "right inner sensor"
    @test Arlett.sensorcases(90.0) == "right outer sensor"
end

# @testset "wallcases() in locations_arlett.jl" begin
#
# end
