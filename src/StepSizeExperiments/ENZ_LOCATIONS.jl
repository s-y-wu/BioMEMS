# Author: Sean Wu
# Last Updated: December 11, 2020

# include("ENZ_PARAMETERS")

# function flow(XY)
#     return 0
# end

function inSensor(XY)
    x_val, y_val = XY
    withinX = abs(x_val) < sensorHalfWidth
    withinY = y_val < 0
    return withinX && withinY
end

function inWalls(x_val, y_val)
    withinX = sensorHalfWidth < abs(x_val) <= escapeX
    withinY = y_val < 0
    return withinX && withinY
end

function inEnz(XY)
    withinX = enzymeLeftX <= XY[1] <= enzymeRightX
    withinY = wallY < XY[2] <= enzymeMaxY
    return withinX && withinY
end

function inWater(XY)
    x_val, y_val = XY
    aboveEnzX = abs(x_val) <= escapeX
    aboveEnzY = enzymeMaxY < y_val <= escapeY
    besideEnzX = enzymeRightX < abs(x_val) <= escapeX
    besideEnzY = wallY < y_val <= enzymeMaxY
    return (aboveEnzX && aboveEnzY) || (besideEnzX && besideEnzY)
end

function inPPD(XY)
    return false
end

function sensorCases(x_val)
    return "sensor"
end
