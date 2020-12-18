"Simulation Controls"
const NUMBER_OF_WALKS = 1000
const MAX_STEPS_PER_WALK = 1485604
const FLOW_OFF = false
const PPD_ON = true  # no PPD == false

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const SECONDS_PER_STEP = 0.0000027077
const WATER_STEP_SIZE = 0.1
const ENZ_STEP_SIZE = 0
# varying "ppd" step size
if PPD_ON
    global PPD_STEP_SIZE = 0.001
else
    global PPD_STEP_SIZE = WATER_STEP_SIZE
end
global STEP_SIZE_DICT = Dict("water" => WATER_STEP_SIZE, "enz" => 0, "ppd" => PPD_STEP_SIZE)

"Sensor/Walls Coordinates"
const SENSOR_HALF_WIDTH = 0.5 * 25
const WALL_Y = 1.5

"PPD Layer Dimensions"
const PPD_MAX_Y = 0.15
const PPD_MIN_Y = 0

"No Enzyme Layer (Variable Stubs)"
const ENZYME_LEFT_X = 0
const ENZYME_RIGHT_X = 0
const ENZYME_MAX_Y_FROM_WALL = 0
const ENZYME_MAX_Y = 0
const BORDER_CORRECTION = 0
const SPAWN_RIGHT_X = 0
const SPAWN_ENZYME_MAX_Y = 0
const CORNER_CUT_IN_ENZ = 0
const CORNER_CUT_IN_WATER = 0
const WATER_TO_ENZ_NORTHEAST = [0, 0]
const WATER_TO_ENZ_NORTHWEST = [0, 0]
const ENZ_TO_WATER_NORTHEAST = [0, 0]
const ENZ_TO_WATER_NORTHWEST = [0, 0]

"Rectangular Spawn Region from Water"
const MARGIN_OF_SPAWN = 5 * WATER_STEP_SIZE
const SPAWN_LEFT_X = MARGIN_OF_SPAWN - SENSOR_HALF_WIDTH
const SPAWN_TOP_LEFT_XY = [SPAWN_LEFT_X, WALL_Y - MARGIN_OF_SPAWN]
const SPAWN_X_RANGE = 2 * SENSOR_HALF_WIDTH - 2 * MARGIN_OF_SPAWN
const SPAWN_Y_RANGE = WALL_Y - PPD_MAX_Y - 2 * MARGIN_OF_SPAWN

"Escape Bound Limits"
const ESCAPE_X = 5 * SENSOR_HALF_WIDTH
const ESCAPE_Y = ESCAPE_X

"Safe Bound Limits"
const MARGIN_OF_COLLISION = 2 * WATER_STEP_SIZE
const SAFE_MIN_Y = WALL_Y + MARGIN_OF_COLLISION
const SAFE_MAX_Y = ESCAPE_Y - MARGIN_OF_COLLISION
const SAFE_MAX_X = ESCAPE_X - MARGIN_OF_COLLISION
