# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")
#include("LocationBools.jl")

"Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector"
function sensWall(initXY, dx, dy, stepSize)
    x, y = initXY
    newX = x + stepSize*dx
    newY = y + stepSize*dy

    if inWalls(newX, newY)
        return sensWall(initXY, dx, dy, stepSize * 0.8)
    else
        return [newX, newY]
    end
end
