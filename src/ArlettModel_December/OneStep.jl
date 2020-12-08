# Author: Sean Wu
# Last Updated: November 12, 2020

#include("boundaryCheck.jl")

function oneStep(initialXY)
    theta = -1*pi + 2*pi*rand(Float64)  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)
    waterStepSize = stepSizeDict["water"]

    initX, initY = initialXY
    if inSafeBounds(initX, initY)   # fast computation
        flowBias = flow(initialXY)
        newX = initX + waterStepSize * dx + flowBias
        newY = initY + waterStepSize * dy
        return [newX, newY], "no collision"
    else                            # more computation needed
        return boundaryCheck(initialXY, dx, dy)
    end
end

function inSafeBounds(x_val, y_val)
    withinX = abs(x_val) < safeMaxX
    withinY = safeMinY < y_val < safeMaxX
    return withinX && withinY
end
