using Test
import HMCResearchRandomWalks.Arlett
using HMCResearchRandomWalks.Arlett:
    approach_wall!, boundary_check,
    north!, eastwest!, evaluate_proposed,
    watercalc, enzcalc, ppdcalc,
    one_step!, insafebounds, inescapebounds,
    run_sim!, randseed


@test approach_wall!([12.42, 1.0], 1.0, 0.0, 0.1) == [12.42 + 0.1 * 0.5, 1.0]
@test approach_wall!([15, 1.7], 0.0, -1.0, 1.0) == [15, 1.7 - 1.0 * 0.5 * 0.5 * 0.5]


function test_xy(testxy::Array{Float64,1},
                            correctxy::Array{Float64,1})
    @test 1000 * testxy[1] ≈ 1000 * correctxy[1]
    @test 1000 * testxy[2] ≈ 1000 * correctxy[2]
end

# Vertical Proposed Point via North!
# enz_water
@testset "vertical displacement at water-enz" begin
    correct_below = [0.0, 1.6475]
    correct_above = [0.0, 1.7]
    wrong_below = [0.0, 1.6]
    wrong_above = [0.0, 1.6525]
    test_below = north!(wrong_below, correct_above, 0.0, -1.0, "water", "enz")
    test_above = north!(wrong_above, correct_below, 0.0, 1.0, "enz", "water")
    #test_below_bc = boundary_check(correct_above, 0.0, -1.0)[1]
    #test_above_bc = boundary_check(correct_below, 0.0, 1.0)[1]
    test_xy(test_below, correct_below)
    test_xy(test_above, correct_above)
    #test_xy(test_below_bc, correct_below)
    #test_xy(test_above_bc, correct_above)
end

const diagonal = sqrt(2) / 2

@testset "positive slope displacement at enz-ppd" begin
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
    test_xy(test_below, correct_below)
    test_xy(test_above, correct_above)
end

@testset "negative slope displacement at water-ppd" begin
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
        test_xy(test_below, correct_below)
        test_xy(test_above, correct_above)
    end
end


#@test north!()

#Arlett.set_CATALASE_ON_WALLS(false)
#@test boundary_check([])
