# Author: Sean Wu
# Last Updated: December 09, 2020

#include("ArlettParameters.jl")
#include("OneStep.jl")

"true when inside parylene walls"
function inWalls(x_val, y_val)
    withinX = !inCenterSensorX(x_val) && !inInnerSensorX(x_val) && !inOuterSensorX(x_val)
    withinY = y_val <= WALL_Y
    return withinX && withinY
end

"true when outside sensors ppd and enzyme layers"
function inWater(xyCoord)
    x, y = xyCoord
    inAdjWellWater = PPD_MAX_Y < y <= WALL_Y && inInnerSensorX(x) || inOuterSensorX(x)
    inWaterAboveWalls = y > WALL_Y && inescapebounds(x, y) && !inOverflowEnz(x, y)
    return inAdjWellWater || inWaterAboveWalls
end

function inEnz(xyCoord)
    x, y = xyCoord
    if PPD_MAX_Y < y <= WALL_Y
        return inCenterSensorX(x)
    else
        return inOverflowEnz(x, y)
    end
end

"true when inside the 150 nm thick layer of m-phenylendiamine (PPD) on each sensor pads"
function inPPD(xyCoord)
    x,y = xyCoord
    inPPDX = inCenterSensorX(x) || inInnerSensorX(x) || inOuterSensorX(x)
    inPPDY = PPD_MIN_Y < y <= PPD_MAX_Y
    return inPPDX && inPPDY
end


function inOverflowEnz(x_val, y_val)
    withinX = ENZYME_LEFT_X <= x_val <= ENZYME_RIGHT_X
    withinY = WALL_Y < y_val <= ENZYME_MAX_Y
    return withinX && withinY
end

function inCenterSensorX(x_val)
    return abs(x_val) < SENSOR_CENTER_MAX_X
end

function inInnerSensorX(x_val)
    return SENSOR_INNER_ADJ_MIN_X < abs(x_val) < SENSOR_INNER_ADJ_MAX_X
end

function inOuterSensorX(x_val)
    return SENSOR_OUTER_ADJ_MIN_X < abs(x_val) < SENSOR_OUTER_ADJ_MAX_X
end

function inSensor(xyCoord)
    y = xyCoord[2]
    return y <= 0
end

function sensorcases(initX)
    if inCenterSensorX(initX)
        return "center sensor"
    elseif initX < 0
        position = "left"
    else
        position = "right"
    end

    if inInnerSensorX(initX)
        return position * " inner sensor"
    elseif inOuterSensorX(initX)
        return position * " outer sensor"
    else
        println("sensorCases error ", initX)
        return "sensorCases error"
    end
end
