# Author: Sean Wu
# Last Updated: November 11, 2020

#include("ArlettParameters.jl")

"Spawning above walls for overflowing enzyme layer"
function spawnrandompoint(randFloat::Float64)::Array{Float64,1}
    spawnLineLength = ENZYME_RIGHT_X - ENZYME_LEFT_X + 2 * ENZYME_MAX_Y_FROM_WALL
    spawnCoordinate = spawnLineLength * randFloat - spawnLineLength / 2

    #Top Enzyme Face
    if SPAWN_LEFT_X <= spawnCoordinate <= SPAWN_RIGHT_X
        return [spawnCoordinate, SPAWN_ENZYME_MAX_Y]
    else
        randomY = WALL_Y + abs(spawnCoordinate) - SPAWN_RIGHT_X
        if spawnCoordinate < 0              #Left Enzyme Side
            return [SPAWN_LEFT_X, randomY]
        else                                #Top Enzyme Face
            return [SPAWN_RIGHT_X, randomY]
        end
    end
end

"Assigns an entering molecule W, NW, N, NE, E (cardinal directions) at the water-enzyme boundary"
function whereOutsideSpawn(xy::Array{Float64,1})::String
    x, y = xy
    if x < ENZYME_LEFT_X
        if y > ENZYME_MAX_Y
            return "NW"
        else
            return "W"
        end
    elseif x > ENZYME_RIGHT_X
        if y > ENZYME_MAX_Y
            return "NE"
        else
            return "E"
        end
    elseif y > ENZYME_MAX_Y
        return "N"
    else
        return "whereOutsideSpawn Error"
    end
end
