"Spawning above walls for overflowing enzyme layer"
function spawnrandompoint(randfloat::Float64=rand(), randfloatstub::Float64=rand())::Array{Float64,1}
    spawnlinelength = ENZYME_RIGHT_X - ENZYME_LEFT_X + 2 * ENZYME_MAX_Y_FROM_WALL
    spawncoordinate = spawnlinelength * randfloat - spawnlinelength / 2

    #Top Enzyme Face
    if SPAWN_LEFT_X <= spawncoordinate <= SPAWN_RIGHT_X
        return [spawncoordinate, SPAWN_ENZYME_MAX_Y]
    else
        randomy = WALL_Y + abs(spawncoordinate) - SPAWN_RIGHT_X
        if spawncoordinate < 0              #Left Enzyme Side
            return [SPAWN_LEFT_X, randomy]
        else                                #Top Enzyme Face
            return [SPAWN_RIGHT_X, randomy]
        end
    end
end

"Assigns an entering molecule W, NW, N, NE, E (cardinal directions) at the water-enzyme boundary"
function whereoutsidespawn(xy::Array{Float64,1})::String
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
        return "whereoutsidespawn Error"
    end
end
