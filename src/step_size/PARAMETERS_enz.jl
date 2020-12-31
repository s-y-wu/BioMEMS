"Simulation Controls"
global NUMBER_OF_WALKS = 1000
global MAX_STEPS_PER_WALK = 3*1485604
global THICK_ENZ = true  # thin enzyme == false
const FLOW_BIAS = true
const CATALASE_ON_WALLS = false

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const SECONDS_PER_STEP = 0.0000027077
const WATER_STEP_SIZE = 0.1
const PPD_STEP_SIZE = 0

function set_ENZ_STEP_SIZE(enz_step::AbstractFloat=0.005)
    global ENZ_STEP_SIZE = enz_step
    global STEP_SIZE_DICT = Dict("water" => WATER_STEP_SIZE,
                                "enz" => ENZ_STEP_SIZE,
                                "ppd" => 0)
    nothing
end
set_ENZ_STEP_SIZE()

"Sensor/Walls Coordinates"
const SENSOR_HALF_WIDTH = 0.5 * 280
const WALL_Y = 0

"Enzyme Layer Dimensions"
function update_enz()
    if THICK_ENZ
        global ENZYME_MAX_Y = 2
        global ENZYME_MAX_Y_FROM_WALL = 2
    else
        global ENZYME_MAX_Y_FROM_WALL = 0.2
        global ENZYME_MAX_Y = 0.2
    end
    nothing
end

function set_THICK_ENZ(trueorfalse::Bool=true)
    global THICK_ENZ = trueorfalse
    update_enz()
    nothing
end

const ENZYME_RIGHT_X = 150
const ENZYME_LEFT_X = -150
update_enz()

"Spawn Inside Enzyme Layer"
const BORDER_CORRECTION = 0.001
const SPAWN_LEFT_X = ENZYME_LEFT_X + BORDER_CORRECTION
const SPAWN_RIGHT_X = ENZYME_RIGHT_X - BORDER_CORRECTION
const SPAWN_ENZYME_MAX_Y = ENZYME_MAX_Y - BORDER_CORRECTION

"Enzyme-Water Corners"
const CORNER_CUT_IN_ENZ = sqrt(2) * ENZ_STEP_SIZE
const CORNER_CUT_IN_WATER = sqrt(2) * WATER_STEP_SIZE
# test set: locationbools here
const WATER_TO_ENZ_NORTHEAST = [ENZYME_RIGHT_X - CORNER_CUT_IN_ENZ, ENZYME_MAX_Y - CORNER_CUT_IN_ENZ]
const WATER_TO_ENZ_NORTHWEST = [ENZYME_LEFT_X + CORNER_CUT_IN_ENZ, ENZYME_MAX_Y - CORNER_CUT_IN_ENZ]
const ENZ_TO_WATER_NORTHEAST = [ENZYME_RIGHT_X + CORNER_CUT_IN_WATER, ENZYME_MAX_Y + CORNER_CUT_IN_WATER]
const ENZ_TO_WATER_NORTHWEST = [ENZYME_LEFT_X - CORNER_CUT_IN_WATER, ENZYME_MAX_Y + CORNER_CUT_IN_WATER]

"Escape Bound Limits"
const ESCAPE_X = 3 * ENZYME_RIGHT_X
const ESCAPE_Y = ESCAPE_X

"Safe Bound Limits"
const MARGIN_OF_COLLISION = 2 * WATER_STEP_SIZE
const SAFE_MIN_Y = ENZYME_MAX_Y + MARGIN_OF_COLLISION
const SAFE_MAX_Y = ESCAPE_Y - MARGIN_OF_COLLISION
const SAFE_MAX_X = ESCAPE_X - MARGIN_OF_COLLISION
