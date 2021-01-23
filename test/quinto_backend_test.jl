using Test
using HMCResearchRandomWalks.Quinto

const smallest_stepsize = min(Quinto.WATER_STEP_SIZE,
                            Quinto.ENZ_STEP_SIZE,
                            Quinto.PPD_STEP_SIZE)
const significant_err = smallest_stepsize / Quinto.MAX_STEPS_PER_WALK
const diagonal = sqrt(2) / 2

function test_xy(testxy::Array{Float64,1}, correctxy::Array{Float64,1})
    @test isapprox(testxy[1], correctxy[1], atol=significant_err)
    @test isapprox(testxy[2], correctxy[2], atol=significant_err)
end


@testset "Evaluate Proposed" begin

# Water-Enz, West, Sensor 1
test_xy(Quinto.evaluate_proposed([-2.05, 0.5], 1.0, 0.0)[1], [-1.9975, 0.5])
test_xy(Quinto.evaluate_proposed([-1.9975, 0.5], -1.0, 0.0)[1], [-2.05, 0.5])
# Water-Enz, NorthWest, Sensor 2
nw_water_2 = [47.95, 3.01]
correct_WATER_TO_ENZ_NORTHWEST = [48.0 + 0.005 * sqrt(2) / 2, 3 - 0.005 * sqrt(2) / 2]
test_xy(Quinto.evaluate_proposed(nw_water_2, diagonal, -1 * diagonal)[1],
        correct_WATER_TO_ENZ_NORTHWEST)
nw_enz_2 = [48.00001, 2.99999]
correct_ENZ_TO_WATER_NORTHWEST =  [48.0 - 0.1 * sqrt(2) / 2, 3 + 0.1 * sqrt(2) / 2]
test_xy(Quinto.evaluate_proposed(nw_enz_2, -1 * diagonal, diagonal)[1],
        correct_ENZ_TO_WATER_NORTHWEST)
# Water-Enz, North, sensor 3
test_xy(Quinto.evaluate_proposed([105.0, 2.9975], 0.0, 1.0)[1], [105.0, 3.05])
test_xy(Quinto.evaluate_proposed([105.0, 3.05], 0.0, -1.0)[1], [105.0, 2.9975])
# Water-Enz, NorthEast, sensor 4
ne_water_4 = [177.01, 3.01]
correct_WATER_TO_ENZ_NORTHEAST = [177.0 - 0.005 * diagonal, 3 - 0.005 * diagonal]
test_xy(Quinto.evaluate_proposed(ne_water_4, -1 * diagonal, -1 * diagonal)[1],
        correct_WATER_TO_ENZ_NORTHEAST)
ne_enz_4 = [176.9999, 2.99999]
correct_ENZ_TO_WATER_NORTHEAST = [177.0 + 0.1 * diagonal, 3 + 0.1 * diagonal]
test_xy(Quinto.evaluate_proposed(ne_enz_4, diagonal, diagonal)[1],
        correct_ENZ_TO_WATER_NORTHEAST)
# Water-Enz, East, sensor 1
test_xy(Quinto.evaluate_proposed([76.9975, 0.5], 1.0, 0.0)[1], [77.05, 0.5])
test_xy(Quinto.evaluate_proposed([77.05, 0.5], -1.0, 0.0)[1], [76.9975, 0.5])
# PPD-Enz, West, sensor 3
test_xy(Quinto.evaluate_proposed([99.9975, 0.10], 1.0, 0.0)[1], [100.0005, 0.10])
test_xy(Quinto.evaluate_proposed([100.0005, 0.10], -1.0, 0.0)[1], [99.9975, 0.10])
# PPD-Enz, NorthWest, sensor 2
correct_PPD_TO_ENZ_NORTHWEST = [50.0 - 0.005 * diagonal, 0.15 + 0.005 * diagonal]
test_xy(Quinto.evaluate_proposed([50.00001, 0.149999], -1 * diagonal, diagonal)[1],
        correct_PPD_TO_ENZ_NORTHWEST)
correct_ENZ_TO_PPD_NORTHWEST = [50.0 + 0.001 * diagonal, 0.15 - 0.001 * diagonal]
test_xy(Quinto.evaluate_proposed([49.9999, 0.15001], diagonal, -1 * diagonal)[1],
        correct_ENZ_TO_PPD_NORTHWEST)
# PPD-Enz, North, sensor 4
test_xy(Quinto.evaluate_proposed([160.0, 0.1495], 0.0, 1.0)[1], [160.0, 0.1525])
test_xy(Quinto.evaluate_proposed([160.0, 0.1525], 0.0, -1.0)[1], [160.0, 0.1495])
# PPD-Enz, NorthEast, sensor 1
correct_PPD_TO_ENZ_NORTHEAST = [25.0 + 0.005 * diagonal, 0.15 + 0.005 * diagonal]
test_xy(Quinto.evaluate_proposed([24.9999, 0.1499], diagonal, diagonal)[1],
        correct_PPD_TO_ENZ_NORTHEAST)
correct_ENZ_TO_PPD_NORTHEAST = [25.0 - 0.001 * diagonal, 0.15 - 0.001 * diagonal]
test_xy(Quinto.evaluate_proposed([25.0001, 0.150001], -1 * diagonal, -1 * diagonal)[1],
        correct_ENZ_TO_PPD_NORTHEAST)
# PPD-Enz, East, sensor 2
test_xy(Quinto.evaluate_proposed([74.9995, 0.05], 1.0, 0.0)[1], [75.0025, 0.05])
test_xy(Quinto.evaluate_proposed([75.0025, 0.05], -1.0, 0.0)[1], [74.9995, 0.05])
end
