# Author: Sean Wu
# Last Updated: December 09, 2020

#include("ArlettParameters.jl")

function inEscapeBounds(x_val, y_val)
    withinX = -1*escapeX <= x_val <= escapeX
    withinY = -1 <= y_val <= escapeY
    return withinX && withinY
end

"true when inside parylene walls"
function inWalls(x_val, y_val)
    withinX = !inCenterSensorX(x_val) && !inInnerSensorX(x_val) && !inOuterSensorX(x_val)
    withinY = y_val <= wallY
    return withinX && withinY
end

function inOverflowEnz(x_val, y_val)
    withinX = enzymaticLeftX <= x_val <= enzymaticRightX
    withinY = wallY < y_val <= enzymeMaxY
    return withinX && withinY
end

function inCenterSensorX(x_val)
    return abs(x_val) < sensorCenterMaxX
end

function inInnerSensorX(x_val)
    return sensorInnerAdjMinX < abs(x_val) < sensorInnerAdjMaxX
end

function inOuterSensorX(x_val)
    return sensorOuterAdjMinX < abs(x_val) < sensorOuterAdjMaxX
end

function inSensor(xyCoord)
    y = xyCoord[2]
    return y <= 0
end

"true when outside sensors ppd and enzymatic layers"
function inWater(xyCoord)
    x, y = xyCoord
    inAdjWellWater = ppdMaxY < y <= wallY && inInnerSensorX(x) || inOuterSensorX(x)
    inWaterAboveWalls = y > wallY && inEscapeBounds(x, y) && !inOverflowEnz(x, y)
    return inAdjWellWater || inWaterAboveWalls
end

function inEnz(xyCoord)
    x, y = xyCoord
    if ppdMaxY < y <= wallY
        return inCenterSensorX(x)
    else
        return inOverflowEnz(x, y)
    end
end

"true when inside the 150 nm thick layer of m-phenylendiamine (PPD) on each sensor pads"
function inPPD(xyCoord)
    x,y = xyCoord
    inPPDX = inCenterSensorX(x) || inInnerSensorX(x) || inOuterSensorX(x)
    inPPDY = ppdMinY < y <= ppdMaxY
    return inPPDX && inPPDY
end
