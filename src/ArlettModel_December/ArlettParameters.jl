# Author: Sean Wu

# Unless noted otherwise, lengths and coordinates are in microns

"Simulation Controls"
NUMBER_OF_WALKS = 100
MAX_STEPS_PER_WALK = 3*1485604
FLOW_OFF = false

"Sensor/Walls Coordinates"
sensorHalfWidth = 0.5 * 25
sensorSpacing = 20
sensorCenterMaxX = sensorHalfWidth
sensorInnerAdjMinX = sensorHalfWidth + sensorSpacing
sensorInnerAdjMaxX = 3 * sensorHalfWidth + sensorSpacing
sensorOuterAdjMinX = 3 * sensorHalfWidth + 2 * sensorSpacing
sensorOuterAdjMaxX = 5 * sensorHalfWidth + 2 * sensorSpacing

"PPD Layer Dimensions"
ppdMaxY = 0.15
ppdMinY = 0

"Enzymatic Layer Dimensions"
enzymaticLeftX = -13.5
enzymaticRightX = 13.5
wallY = 1.5
enzymeMaxYFromWall = 0.15
enzymeMaxY = wallY + enzymeMaxYFromWall

"Spawn Inside Enzymatic Layer"
borderCorrection = 0.001
spawnLeftX = enzymaticLeftX + borderCorrection
spawnRightX = enzymaticRightX - borderCorrection
spawnEnzymeMaxY = enzymeMaxY - borderCorrection

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
stepSizeDict = Dict("water" => 0.1, "enz" => 0.005, "ppd" => 0.0007)

"Escape Bound Limits"
escapeX = 5 * sensorHalfWidth + 3 * sensorSpacing
escapeY = escapeX

"Safe Bound Limits"
marginOfCollision = 5 * stepSizeDict["water"]
safeMinY = enzymeMaxY + marginOfCollision
safeMaxY = escapeY - marginOfCollision
safeMaxX = escapeX - marginOfCollision
