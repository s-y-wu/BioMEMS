using Test, Suppressor
import HMCResearchRandomWalks.Arlett
using HMCResearchRandomWalks.Arlett:
    approach_wall!, boundary_check,
    north!, eastwest!, evaluate_proposed,
    one_step!, insafebounds, inescapebounds,
    randseed
    
# see arlett_frontend_tests.jl for run_sim.jl
# see arlett_backend_tests.jl for all other location ("in...") functions

const smallest_stepsize = min(Arlett.WATER_STEP_SIZE,
                            Arlett.ENZ_STEP_SIZE,
                            Arlett.PPD_STEP_SIZE)
const significant_err = smallest_stepsize / Arlett.MAX_STEPS_PER_WALK
const diagonal = sqrt(2) / 2

function test_xy(testxy::Array{Float64,1},
                            correctxy::Array{Float64,1})
    @test isapprox(testxy[1], correctxy[1], atol=significant_err)
    @test isapprox(testxy[2], correctxy[2], atol=significant_err)
end

# Vertical Proposed Point via North!
# enz_water
@testset "vertical displacement at water-enz" begin
    Arlett.set_FLOW_BIAS(false)
    correct_below = [0.0, 1.6475]
    correct_above = [0.0, 1.7]
    wrong_below = [0.0, 1.6]
    wrong_above = [0.0, 1.6525]
    test_below = north!(wrong_below, correct_above, 0.0, -1.0, "water", "enz")
    test_above = north!(wrong_above, correct_below, 0.0, 1.0, "enz", "water")
    test_below_ep = evaluate_proposed(correct_above, 0.0, -1.0)[1]
    test_above_ep = evaluate_proposed(correct_below, 0.0, 1.0)[1]
    test_below_bc = boundary_check(correct_above, 0.0, -1.0)[1]
    test_above_bc = boundary_check(correct_below, 0.0, 1.0)[1]
    test_xy(test_below, correct_below)
    test_xy(test_above, correct_above)
    test_xy(test_below_ep, correct_below)
    test_xy(test_above_ep, correct_above)
    test_xy(test_below_bc, correct_below)
    test_xy(test_above_bc, correct_above)
end

@testset "positive slope displacement at enz-ppd" begin
    Arlett.set_FLOW_BIAS(false)
    correct_below = [0.0, 0.15 - 0.001 * diagonal / 2]
    correct_above = [0.0 + (0.001 + 0.005) * diagonal / 2,
                        0.15 + 0.005 * diagonal / 2]
    wrong_above = [0 + 0.001 * diagonal,
                        0.15 + 0.001 * diagonal / 2]
    wrong_below = [0.0 + (0.001 - 0.005) * diagonal / 2,
                        0.15 - 0.005 * diagonal / 2]
    test_above = north!(wrong_above, correct_below,
                         diagonal, diagonal, "ppd", "enz")
    test_below = north!(wrong_below, correct_above,
                         -1 * diagonal, -1 * diagonal, "enz", "ppd")
    test_above_ep = evaluate_proposed(correct_below, diagonal, diagonal)[1]
    test_below_ep = evaluate_proposed(correct_above, -1 * diagonal, -1 * diagonal)[1]
    test_above_bc = boundary_check(correct_below, diagonal, diagonal)[1]
    test_below_bc = boundary_check(correct_above, -1 * diagonal, -1 * diagonal)[1]
    test_xy(test_below, correct_below)
    test_xy(test_above, correct_above)
    test_xy(test_below_ep, correct_below)
    test_xy(test_above_ep, correct_above)
    test_xy(test_below_bc, correct_below)
    test_xy(test_above_bc, correct_above)
end

@testset "negative slope displacement at water-ppd" begin
    Arlett.set_FLOW_BIAS(false)
    for x in [-90, -45, 45, 90]
        correct_above = [x, 0.15 + 0.1 * diagonal / 2]
        correct_below = [x + (0.1 + 0.001) * diagonal / 2,
                            0.15 - 0.001 * diagonal / 2]
        wrong_below = [x + 0.1 * diagonal,
                            0.15 - 0.1 * diagonal / 2]
        wrong_above = [x + (0.1 - 0.001) * diagonal / 2,
                            0.15 + 0.001 * diagonal / 2]
        test_above = north!(wrong_above, correct_below,
                            -1 * diagonal, diagonal, "ppd", "water")
        test_below = north!(wrong_below, correct_above,
                            diagonal, -1 * diagonal, "water", "ppd")
        test_above_ep = evaluate_proposed(correct_below, -1 * diagonal, diagonal)[1]
        test_below_ep = evaluate_proposed(correct_above, diagonal, -1 * diagonal)[1]
        test_above_bc = boundary_check(correct_below, -1 * diagonal, diagonal)[1]
        test_below_bc = boundary_check(correct_above, diagonal, -1 * diagonal)[1]
        test_xy(test_below, correct_below)
        test_xy(test_above, correct_above)
        test_xy(test_below_ep, correct_below)
        test_xy(test_above_ep, correct_above)
        test_xy(test_below_bc, correct_below)
        test_xy(test_above_bc, correct_above)
    end
end

@testset "universal location functions in one_step!.jl" begin
    for safexy in [[0.0, 2.0],[122.2, 122.2],[-122.2,112.2]]
        @test Arlett.insafebounds(safexy)
        @test Arlett.inescapebounds(safexy)
    end
    for escapexy in [[0.0, 0.0],[122.5, 122.5],[-122.5, 122.5]]
        @test Arlett.inescapebounds(escapexy)
        @test !Arlett.insafebounds(escapexy)
    end
    for notescapexy in [[122.6, 122.5],[122.6, 122.6],[-122.5, 122.6],
                            [-122.6, 122.5],[0.0, -2.0]]
        @test !Arlett.inescapebounds(notescapexy)
        @test !Arlett.insafebounds(notescapexy)
    end
end

@testset "approch_wall!.jl and wallcases()" begin
    correct_wall_side = [57.42 + 0.1 * 0.5, 1.0]
    test_wall_side_aw = approach_wall!([57.42, 1.0], 1.0, 0.0, 0.1)
    test_wall_side_wc = Arlett.wallcases([57.42, 1.0], 1.0, 0.0, 0.1)[1]
    test_wall_side_bc = boundary_check([57.42, 1.0], 1.0, 0.0)[1]
    test_xy(test_wall_side_aw, correct_wall_side)
    test_xy(test_wall_side_wc, correct_wall_side)
    test_xy(test_wall_side_bc, correct_wall_side)

    Arlett.set_CATALASE_ON_WALLS(false)
    Arlett.set_FLOW_BIAS(false)
    correct_wall_top = [15, 1.51 - 0.1 * 0.5 * 0.5 * 0.5 * 0.5]
    test_wall_top_aw = approach_wall!([15, 1.51], 0.0, -1.0, 0.1)
    test_wall_top_wc = Arlett.wallcases([15, 1.51], 0.0, -1.0, 0.1)[1]
    test_wall_top_bc = boundary_check([15, 1.51], 0.0, -1.0)[1]
    test_xy(test_wall_top_aw, correct_wall_top)
    test_xy(test_wall_top_wc, correct_wall_top)
    test_xy(test_wall_top_bc, correct_wall_top)
end

@testset "onestep!" begin
    init_xy = [0.0, 50.0]
    copy_xy = copy(init_xy)

    next_xy = one_step!(copy_xy)[1]

    @test init_xy != copy_xy
    @test copy_xy === next_xy

    @test -0.1 <= next_xy[1] <= 0.1
    @test 49.9 <= next_xy[2] <= 50.1
    d = sqrt(
        (next_xy[1] - init_xy[1])^2 +
        (next_xy[2] - init_xy[2])^2
    )
    @test isapprox(d, 0.1, atol=significant_err)
end

@testset "randseed" begin
    @test typeof(Arlett.randseed()) == Int
    @test 0 <= Arlett.randseed() <= 10000
end
