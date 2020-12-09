# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")

"Flow bias using laminar flow approximations. Flow bias increases with y"
function flow(initXY)
    if FLOW_OFF
        return 0
    end

    y = initXY[2]
    if y < wallY
        return 0
    else
        speed = 6327*(1 - ((1270 - y)^2) / (1270^2))
        secondsPerStep = 0.0000027077
        xDisplacementBias = speed * secondsPerStep
        return xDisplacementBias
    end
end
