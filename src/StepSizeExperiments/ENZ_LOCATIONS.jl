# Author: Sean Wu
# Last Updated: December 11, 2020

# include("ENZ_PARAMETERS")

# function flow(xy)
#     return 0
# end

function inSensor(xy)
    x_val, y_val = xy
    withinX = abs(x_val) < SENSOR_HALF_WIDTH
    withinY = y_val < 0
    return withinX && withinY
end

function inWalls(x_val, y_val)
    withinX = SENSOR_HALF_WIDTH < abs(x_val) <= ESCAPE_X
    withinY = y_val < 0
    return withinX && withinY
end

function inEnz(xy)
    withinX = ENZYME_LEFT_X <= xy[1] <= ENZYME_RIGHT_X
    withinY = WALL_Y < xy[2] <= ENZYME_MAX_Y
    return withinX && withinY
end

function inWater(xy)
    x_val, y_val = xy
    aboveEnzX = abs(x_val) <= ESCAPE_X
    aboveEnzY = ENZYME_MAX_Y < y_val <= ESCAPE_Y
    besideEnzX = ENZYME_RIGHT_X < abs(x_val) <= ESCAPE_X
    besideEnzY = WALL_Y < y_val <= ENZYME_MAX_Y
    return (aboveEnzX && aboveEnzY) || (besideEnzX && besideEnzY)
end

function inPPD(xy)
    return false
end

function sensorCases(x_val)
    return "sensor"
end
