# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")

"Spawning above walls for overflowing enzyme layer"
function spawnRandomPoint(randFloat)
    spawnLineLength = enzymeRightX - enzymeLeftX + 2 * enzymeMaxYFromWall
    spawnCoordinate = spawnLineLength * randFloat - spawnLineLength / 2

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
function whereOutsideSpawn(XY)
    x, y = XY
    if x < enzymeLeftX
        if y > enzymeMaxY
            return "NW"
        else
            return "W"
        end
    elseif x > enzymeRightX
        if y > enzymeMaxY
            return "NE"
        else
            return "E"
        end
    elseif y > enzymeMaxY
        return "N"
    else
        return "whereOutsideSpawn Error"
    end
end
