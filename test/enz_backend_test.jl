using Test
using HMCResearchRandomWalks.Enz

"testing functions for locations"
function rand_x() return Enz.ESCAPE_X * rand() * 2 - Enz.ESCAPE_X end
function rand_y() return Enz.ESCAPE_Y * rand() - 0.5 * Enz.ESCAPE_Y end

@test Enz.inwater([rand_x(), 5.0])
