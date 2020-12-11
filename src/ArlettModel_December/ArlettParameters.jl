# Author: Sean Wu

# Unless noted otherwise, lengths and coordinates are in microns

# const variables w/ fixed types perform better than default (global) variables
"Simulation Controls"
const NUMBER_OF_WALKS = 1000
const MAX_STEPS_PER_WALK = 3*1485604
const FLOW_OFF = true

"Sensor/Walls Coordinates"
const sensorHalfWidth = 0.5 * 25
const sensorSpacing = 20
const sensorCenterMaxX = sensorHalfWidth
const sensorInnerAdjMinX = sensorHalfWidth + sensorSpacing
const sensorInnerAdjMaxX = 3 * sensorHalfWidth + sensorSpacing
const sensorOuterAdjMinX = 3 * sensorHalfWidth + 2 * sensorSpacing
const sensorOuterAdjMaxX = 5 * sensorHalfWidth + 2 * sensorSpacing

"PPD Layer Dimensions"
const ppdMaxY = 0.15
const ppdMinY = 0

"Enzymatic Layer Dimensions"
const enzymaticLeftX = -13.5
const enzymaticRightX = 13.5
const wallY = 1.5
const enzymeMaxYFromWall = 0.15
const enzymeMaxY = wallY + enzymeMaxYFromWall

"Spawn Inside Enzymatic Layer"
const borderCorrection = 0.001
const spawnLeftX = enzymaticLeftX + borderCorrection
const spawnRightX = enzymaticRightX - borderCorrection
const spawnEnzymeMaxY = enzymeMaxY - borderCorrection

"Enzymatic-Water Corners"
const cornerCutInEnz = sqrt(2) * enzStepSize
const cornerCutInWater = sqrt(2) * waterStepSize
const waterToEnzNorthEast = [enzymaticRightX - cornerCutInEnz, enzymeMaxY - cornerCutInEnz]
const waterToEnzNorthWest = [enzymaticLeftX + cornerCutInEnz, enzymeMaxY - cornerCutInEnz]
const enzToWaterNorthEast = [enzymaticRightX + cornerCutInWater, enzymeMaxY + cornerCutInWater]
const enzToWaterNorthWest = [enzymaticLeftX - cornerCutInWater, enzymeMaxY + cornerCutInWater]

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
stepSizeDict = Dict("water" => 0.1, "enz" => 0.005, "ppd" => 0.0007)
const waterStepSize = 0.1
const enzStepSize = 0.005
const ppdStepSize = 0.0007

"Escape Bound Limits"
const escapeX = 5 * sensorHalfWidth + 3 * sensorSpacing
const escapeY = escapeX

"Safe Bound Limits"
const marginOfCollision = 2 * waterStepSize
const safeMinY = enzymeMaxY + marginOfCollision
const safeMaxY = escapeY - marginOfCollision
const safeMaxX = escapeX - marginOfCollision
