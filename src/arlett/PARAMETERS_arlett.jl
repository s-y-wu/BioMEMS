# Unless noted otherwise, lengths and coordinates are in microns

# const variables w/ fixed types perform better than default (global) variables
"Simulation Controls: other setters in ~/src/walk_logic/runsim!.jl"
global NUMBER_OF_WALKS = 100
global MAX_STEPS_PER_WALK = 3*1485604
global FLOW_BIAS = true
global CATALASE_ON_WALLS = false

function set_FLOW_BIAS(trueorfalse::Bool=true)
    global FLOW_BIAS = trueorfalse
    return nothing
end

function set_CATALASE_ON_WALLS(trueorfalse::Bool=true)
    global CATALASE_ON_WALLS = trueorfalse
    return nothing
end

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const SECONDS_PER_STEP = 0.0000027077
STEP_SIZE_DICT = Dict("water" => 0.1, "enz" => 0.005, "ppd" => 0.001)
const WATER_STEP_SIZE = 0.1
const ENZ_STEP_SIZE = 0.005
const PPD_STEP_SIZE = 0.001

"Sensor/Walls Coordinates"
const WALL_Y = 1.5
const SENSOR_HALF_WIDTH = 0.5 * 25
const SENSOR_SPACING = 20
const SENSOR_CENTER_MAX_X = SENSOR_HALF_WIDTH
const SENSOR_INNER_ADJ_MIN_X = SENSOR_HALF_WIDTH + SENSOR_SPACING
const SENSOR_INNER_ADJ_MAX_X = 3 * SENSOR_HALF_WIDTH + SENSOR_SPACING
const SENSOR_OUTER_ADJ_MIN_X = 3 * SENSOR_HALF_WIDTH + 2 * SENSOR_SPACING
const SENSOR_OUTER_ADJ_MAX_X = 5 * SENSOR_HALF_WIDTH + 2 * SENSOR_SPACING

"PPD Layer Dimensions"
const PPD_MAX_Y = 0.15
const PPD_MIN_Y = 0

"Enzyme Layer Dimensions"
const ENZYME_LEFT_X = -13.5
const ENZYME_RIGHT_X = 13.5
const ENZYME_MAX_Y_FROM_WALL = 0.15
const ENZYME_MAX_Y = WALL_Y + ENZYME_MAX_Y_FROM_WALL

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
const ESCAPE_X = 5 * SENSOR_HALF_WIDTH + 3 * SENSOR_SPACING
const ESCAPE_Y = ESCAPE_X

"Safe Bound Limits"
const MARGIN_OF_COLLISION = 2 * WATER_STEP_SIZE
const SAFE_MIN_Y = ENZYME_MAX_Y + MARGIN_OF_COLLISION
const SAFE_MAX_Y = ESCAPE_Y - MARGIN_OF_COLLISION
const SAFE_MAX_X = ESCAPE_X - MARGIN_OF_COLLISION
