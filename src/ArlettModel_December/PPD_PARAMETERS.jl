# Author: Sean Wu
# First Written: December 15, 2020

"Simulation Controls"
const NUMBER_OF_WALKS = 10
const MAX_STEPS_PER_WALK = 3*1485604
const FLOW_OFF = false
const PPD_ON = true  # no PPD == false

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const waterStepSize = 0.1
const enzStepSize = 0.005
# varying "ppd" step size
if PPD_ON
    global ppdStepSize = 0.007
else
    global ppdStepSize = waterStepSize
end
global stepSizeDict = Dict("water" => waterStepSize, "enz" => 0.005, "ppd" => ppdStepSize)

"Sensor/Walls Coordinates"
const sensorHalfWidth = 0.5 * 25
const sensorCenterMaxX = sensorHalfWidth
const wallY = 1.5

"PPD Layer Dimensions"
const ppdMaxY = 0.15
const ppdMinY = 0

"No Enzyme Layer (Variable Stubs)"
const enzymeLeftX = 0
const enzymeRightX = 0
const enzymeMaxYFromWall = 0
const enzymeMaxY = 0
const borderCorrection = 0
const spawnRightX = 0
const spawnEnzymeMaxY = 0
const cornerCutInEnz = 0
const cornerCutInWater = 0
const waterToEnzNorthEast = [0, 0]
const waterToEnzNorthWest = [0, 0]
const enzToWaterNorthEast = [0, 0]
const enzToWaterNorthWest = [0, 0]

"Rectangular Spawn Region from Water"
const marginOfSpawn = 5 * waterStepSize
const spawnLeftX = marginOfSpawn - sensorHalfWidth
const spawnTopLeftXY = [spawnLeftX, wallY - marginOfSpawn]
const spawnXRange = 2 * sensorHalfWidth - 2 * marginOfSpawn
const spawnYRange = wallY - ppdMaxY - 2 * marginOfSpawn

"Escape Bound Limits"
const escapeX = 5 * sensorHalfWidth
const escapeY = escapeX

"Safe Bound Limits"
const marginOfCollision = 2 * waterStepSize
const safeMinY = wallY + marginOfCollision
const safeMaxY = escapeY - marginOfCollision
const safeMaxX = escapeX - marginOfCollision
