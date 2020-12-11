# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")
#include("LocationBools.jl")

"Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector"
function sensWall(initXY, dx, dy, stepSize)
    newX = initXY[1] + stepSize*dx
    newY = initXY[2] + stepSize*dy

    if inWalls(newX, newY)
        return sensWall(initXY, dx, dy, stepSize * 0.5)
    else
        initXY[1] = newX
        initXY[2] = newY
        return initXY
    end
end
