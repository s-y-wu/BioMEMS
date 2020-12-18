# include("PPD_PARAMETERS.jl")

function inSensor(xy)
    y = xy[2]
    return y <= PPD_MIN_Y
end

function inWalls(x_val, y_val)
    withinX = SENSOR_HALF_WIDTH < abs(x_val) <= ESCAPE_X
    withinY = PPD_MIN_Y < y_val <= WALL_Y
    return withinX && withinY
end

function inPPD(xy)
    withinX = abs(xy[1]) <= SENSOR_HALF_WIDTH
    withinY = PPD_MIN_Y < xy[2] <= PPD_MAX_Y
    return withinX && withinY
end

function inWater(xy)
    x_val, y_val = xy
    aboveWallX = abs(x_val) <= ESCAPE_X
    aboveWALL_Y = WALL_Y < y_val <= ESCAPE_Y
    inWellX = abs(x_val) <= SENSOR_HALF_WIDTH
    inWellY = PPD_MAX_Y < y_val <= WALL_Y
    return (aboveWallX && aboveWALL_Y) || (inWellX && inWellY)
end

function inEnz(xy)
    # No enzyme layer
    return false
end

function spawnrandompoint(randFloatX)
    randFloatY = rand(Float64)
    newxy = copy(SPAWN_TOP_LEFT_XY)
    newxy[1] += randFloatX * SPAWN_X_RANGE
    newxy[2] -= randFloatY * SPAWN_Y_RANGE
    return newxy
end

function whereOutsideSpawn(xy)
    # No Enzyme Layer, only horizontal inteface between
    # Water and PPD Layer inside sensor well
    return "N"
end

function sensorCases(x_val)
    # only one sensor
    return "sensor"
end
