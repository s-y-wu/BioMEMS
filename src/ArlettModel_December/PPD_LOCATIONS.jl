# include("PPD_PARAMETERS.jl")

function inSensor(XY)
    y = XY[2]
    return y <= ppdMinY
end

function inWalls(x_val, y_val)
    withinX = sensorHalfWidth < abs(x_val) <= escapeX
    withinY = ppdMinY < y_val <= wallY
    return withinX && withinY
end

function inPPD(XY)
    withinX = abs(XY[1]) <= sensorHalfWidth
    withinY = ppdMinY < XY[2] <= ppdMaxY
    return withinX && withinY
end

function inWater(XY)
    x_val, y_val = XY
    aboveWallX = abs(x_val) <= escapeX
    aboveWallY = wallY < y_val <= escapeY
    inWellX = abs(x_val) <= sensorHalfWidth
    inWellY = ppdMaxY < y_val <= wallY
    return (aboveWallX && aboveWallY) || (inWellX && inWellY)
end

function inEnz(XY)
    # No enzyme layer
    return false
end

function spawnRandomPoint(randFloatX)
    randFloatY = rand(Float64)
    newXY = copy(spawnTopLeftXY)
    newXY[1] += randFloatX * spawnXRange
    newXY[2] -= randFloatY * spawnYRange
    return newXY
end

function whereOutsideSpawn(XY)
    # No Enzyme Layer, only horizontal inteface between
    # Water and PPD Layer inside sensor well
    return "N"
end

function sensorCases(x_val)
    # only one sensor
    return "sensor"
end
