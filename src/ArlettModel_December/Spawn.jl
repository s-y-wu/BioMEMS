# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")

"Spawning above walls for overflowing enzymatic layer"
function spawnRandomPoint()
    spawnLineLength = enzymaticRightX - enzymaticLeftX + 2 * enzymeMaxYFromWall
    spawnCoordinate = spawnLineLength * rand(Float64) - spawnLineLength / 2

    #Top Enzyme Face
    if spawnLeftX <= spawnCoordinate <= spawnRightX
        return [spawnCoordinate, spawnEnzymeMaxY]
    else
        randomY = wallY + abs(spawnCoordinate) - spawnRightX
        if spawnCoordinate < 0              #Left Enzyme Side
            return [spawnLeftX, randomY]
        else                                #Top Enzyme Face
            return [spawnRightX, randomY]
        end
    end
end

"Assigns an entering molecule W, NW, N, NE, E (cardinal directions) at the water-enzyme boundary"
function whereOutsideSpawn(point)
    initX, initY = point
    if initX < enzymaticLeftX
        if initY > enzymeMaxY
            return "NW"
        else
            return "W"
        end
    elseif initX > enzymaticRightX
        if initY > enzymeMaxY
            return "NE"
        else
            return "E"
        end
    elseif initY > enzymeMaxY
        return "N"
    else
        return "whereOutsideSpawn Error"
    end
end
