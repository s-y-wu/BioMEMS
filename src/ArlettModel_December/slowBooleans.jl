# Author: Sean Wu
# Last Updated: December 10, 2020

#include("ArlettParameters.jl")

# design philosophy of fast bools: most likely case comes first

function inEscapeBounds(x_val, y_val)
    if abs(x_val) > escapeX
        return false
    else
        return -1 <= y_val <= escapeY
    end
end

function inWalls(x_val, y_val)
    if y_val > wallY
        return false
    else
        if inCenterWallsX(x_val)
            return true
        elseif inInnerWallsX(x_val)
            return true
        elseif inOuterWallsX(x_val)
            return true
        else
            return false
        end
    end
end

function inEnz(xyCoord)
    x, y = xyCoord
    if abs(x) > enzymaticRightX
        return false
    elseif y > enzymeMaxY
        return false
    elseif ppdMaxY < y <= wallY
        return inCenterSensorX(x)
    else
        return inOverflowEnz(x, y)
    end
end

"forget the escape bound"
function inWater(xyCoord)
    x, y = xyCoord
    if y > enzymeMaxY
        return true
    elseif y > wallY
        return abs(x) > enzymaticRightX
    elseif y > ppdMaxY
        return inInnerSensorX(x) || inOuterSensorX(x)
    else
        return false
    end
end

"forget the walls and sensors, separate"
function inPPD(xyCoord)
    x, y = xyCoord
    return y <= ppdMaxY
end

function inSensor(xyCoord)
    y = xyCoord[2]
    return y <= 0
end

function inOverflowEnz(x_val, y_val)
    withinX = abs(x_val) <= enzymaticRightX
    withinY = wallY < y_val <= enzymeMaxY
    return withinX && withinY
end

function inCenterSensorX(x_val)
    return abs(x_val) < sensorCenterMaxX
end

function inCenterWallsX(x_val)
    return sensorCenterMaxX <= abs(x_val) <= sensorInnerAdjMinX
end

function inInnerSensorX(x_val)
    return sensorInnerAdjMinX < abs(x_val) < sensorInnerAdjMaxX
end

function inInnerWallsX(x_val)
    return sensorInnerAdjMaxX <= abs(x_val) <= sensorOuterAdjMinX
end

function inOuterSensorX(x_val)
    return sensorOuterAdjMinX < abs(x_val) < sensorOuterAdjMaxX
end

function inOuterWallsX(x_val)
    return sensorOuterAdjMaxX <= abs(x_val) <= escapeX
end
