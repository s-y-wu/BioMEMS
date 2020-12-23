"""
    spawnrandompoint(ranfloat, randfloat) -> Array{Float64,1}

Initialize an [x,y] coordinate, uniformly random at water-enz interface, just inside enz.
"""
function spawnrandompoint(randfloat::Float64=rand(), randfloatstub::Float64=rand())
    spawnlinelength = SPAWN_RIGHT_X - SPAWN_LEFT_X + 2 * (SPAWN_ENZYME_MAX_Y - WALL_Y)
    spawncoordinate = spawnlinelength * randfloat - spawnlinelength / 2

    #Top Enzyme Face
    if SPAWN_LEFT_X <= spawncoordinate <= SPAWN_RIGHT_X
        return [spawncoordinate, SPAWN_ENZYME_MAX_Y]
    else
        randomy = SPAWN_ENZYME_MAX_Y + SPAWN_RIGHT_X - abs(spawncoordinate)
        if isapprox(randomy, WALL_Y)        # spawn outside wall
            randomy += BORDER_CORRECTION
        end

        if spawncoordinate < 0              #Left Enzyme Side
            return [SPAWN_LEFT_X, randomy]
        else                                #Top Enzyme Face
            return [SPAWN_RIGHT_X, randomy]
        end
    end
end

"""
    whereoutsidespawn(xy)

Assign a cardinal direction (W, NW, N, NE, or E) when crossing the water-enzyme boundary
"""
function whereoutsidespawn(xy::Array{Float64,1})
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
