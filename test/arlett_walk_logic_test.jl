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

#below_enz =
#@test north!()

#Arlett.set_CATALASE_ON_WALLS(false)
#@test boundary_check([])
