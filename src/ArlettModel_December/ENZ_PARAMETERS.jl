# Author: Sean Wu
# Last Updated: December 11, 2020

"Simulation Controls"
const NUMBER_OF_WALKS = 500
const MAX_STEPS_PER_WALK = 3*1485604
const FLOW_OFF = false
const THICK_ENZ = true  # thin enzyme == false

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const waterStepSize = 0.1
const ppdStepSize = 0
# varying "enz" step size
global stepSizeDict = Dict("water" => waterStepSize, "enz" => 0.005, "ppd" => 0)
global enzStepSize = 0.005

"Sensor/Walls Coordinates"
const sensorHalfWidth = 0.5 * 280
const sensorCenterMaxX = sensorHalfWidth

"Enzyme Layer Dimensions"
const enzymeRightX = 150
const enzymeLeftX = -150
const wallY = 0
if THICK_ENZ    # thin wall 0.2, thick wall 2
    const enzymeMaxY = 2
    const enzymeMaxYFromWall = 2
else
    const enzymeMaxYFromWall = 0.2
    const enzymeMaxY = 0.2
end


"Spawn Inside Enzyme Layer"
const borderCorrection = 0.001
const spawnLeftX = enzymeLeftX + borderCorrection
const spawnRightX = enzymeRightX - borderCorrection
const spawnEnzymeMaxY = enzymeMaxY - borderCorrection

"Enzyme-Water Corners"
const cornerCutInEnz = sqrt(2) * enzStepSize
const cornerCutInWater = sqrt(2) * waterStepSize
# test set: locationbools here
const waterToEnzNorthEast = [enzymeRightX - cornerCutInEnz, enzymeMaxY - cornerCutInEnz]
const waterToEnzNorthWest = [enzymeLeftX + cornerCutInEnz, enzymeMaxY - cornerCutInEnz]
const enzToWaterNorthEast = [enzymeRightX + cornerCutInWater, enzymeMaxY + cornerCutInWater]
const enzToWaterNorthWest = [enzymeLeftX - cornerCutInWater, enzymeMaxY + cornerCutInWater]

"Escape Bound Limits"
const escapeX = 3 * enzymeRightX
const escapeY = escapeX

"Safe Bound Limits"
const marginOfCollision = 2 * waterStepSize
const safeMinY = enzymeMaxY + marginOfCollision
const safeMaxY = escapeY - marginOfCollision
const safeMaxX = escapeX - marginOfCollision
