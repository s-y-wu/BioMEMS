# Author: Sean Wu
# Last Updated: November 12, 2020

#include("BoundaryCheck.jl")

function runSimulation(data::Dict{String,Integer})
    avgStepsTaken = 0
    arrayOfRandomFloats = rand(NUMBER_OF_WALKS)
    for i in arrayOfRandomFloats
        peroxideXY = spawnRandomPoint(i)
        index = 0
        while peroxideXY != undef && index < MAX_STEPS_PER_WALK
            peroxideXY, collision = oneStep(peroxideXY)
            if collision != "no collision"
                data[collision] += 1
            end
            index += 1
        end
        avgStepsTaken += index
        if index >= MAX_STEPS_PER_WALK
            data["particles unresolved"] += 1
        end
    end
    avgStepsTaken = avgStepsTaken ÷ NUMBER_OF_WALKS
    data["avg steps taken"] = avgStepsTaken
    return data
end

function oneStep(initialXY)
    theta = 2 * pi * rand(Float64) - pi  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)

    if inSafeBounds(initialXY)   # fast computation
        flowBias = flow(initialXY)
        # IMPORTANT: updating arrays always faster than initializing new array
        initialXY[1] += waterStepSize * dx + flowBias
        initialXY[2] += waterStepSize * dy
        return initialXY, "no collision"
    else                            # more computation needed
        return boundaryCheck(initialXY, dx, dy)
    end
end

function inSafeBounds(xy)
    return abs(xy[1]) < safeMaxX && safeMinY < xy[2] && xy[2] < safeMaxY
end

function inEscapeBounds(x_val, y_val)
    withinX = -1*escapeX <= x_val <= escapeX
    withinY = -1 <= y_val <= escapeY
    return withinX && withinY
end
