# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")



function inEscapeBounds(x_val, y_val)
    withinX = -1*escapeX <= x_val <= escapeX
    withinY = -1 <= y_val <= escapeY
    return withinX && withinY
end

"true when inside parylene walls"
function inWalls(x_val, y_val)
    withinX = !inCenterX(x_val) && !inInnerAdjX(x_val) && !inOuterAdjX(x_val)
    withinY = y_val <= wallY
    return withinX && withinY
end

function inOverflowEnz(x_val, y_val)
    withinX = enzymaticLeftX <= x_val <= enzymaticRightX
    withinY = wallY < y_val <= enzymeMaxY
    return withinX && withinY
end

function inCenterX(x_val)
    return abs(x_val) < sensorCenterMaxX
end

function inInnerAdjX(x_val)
    return sensorInnerAdjMinX < abs(x_val) < sensorInnerAdjMaxX
end

function inOuterAdjX(x_val)
    return sensorOuterAdjMaxX < abs(x_val) < sensorOuterAdjMaxX
end

function inSensor(xyCoord)
    y = xyCoord[2]
    return y <= 0
end

"true when outside sensors ppd and enzymatic layers"
function inWater(xyCoord)
    x, y = xyCoord
    inAdjWellWater = ppdMaxY < y <= wallY && inInnerAdjX(x) || inOuterAdjX(x)
    inWaterAboveWalls = y > wallY && inEscapeBounds(x, y) && !inOverflowEnz(x, y)
    return inAdjWellWater || inWaterAboveWalls
end

function inEnz(xyCoord)
    x, y = xyCoord
    if ppdMaxY < y <= wallY
        return inCenterX(x)
    else
        return inOverflowEnz(x, y)
    end
end

"true when inside the 150 nm thick layer of m-phenylendiamine (PPD) on each sensor pads"
function inPPD(xyCoord)
    x,y = xyCoord
    inPPDX = inCenterX(x) || inInnerAdjX(x) || inOuterAdjX(x)
    inPPDY = ppdMinY < y <= ppdMaxY
    return inPPDX && inPPDY
end
