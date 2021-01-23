"Above the center/spawn sensor"
function inspawnsensorx(x::Float64)::Bool
    return SENSOR_SPAWN_LEFT_X < x < SENSOR_SPAWN_RIGHT_X
end

function insecondsensorx(x::Float64)::Bool
    return SENSOR_SECOND_LEFT_X < x < SENSOR_SECOND_RIGHT_X
end

function inthirdsensorx(x::Float64)::Bool
    return SENSOR_THIRD_LEFT_X < x < SENSOR_THIRD_RIGHT_X
end

function infourthsensorx(x::Float64)::Bool
    return SENSOR_FOURTH_LEFT_X < x < SENSOR_FOURTH_RIGHT_X
end

function insensor(xy::Array{Float64, 1})
    x, y = xy
    withinx = inspawnsensorx(x) || insecondsensorx(x) || inthirdsensorx(x) || infourthsensorx(x)
    withiny = y <= WALL_Y
    return withinx && withiny
end

"Parylene walls in between sensors"
function inwalls(x::Float64, y::Float64)::Bool
    withinx = !inspawnsensorx(x) && !insecondsensorx(x) && !inthirdsensorx(x) && !infourthsensorx(x)
    withiny = y <= WALL_Y
    return withinx && withiny
end

"Designate zones to simplify identical four sensors into easier subproblems"
function inzoneone(x::Float64)::Bool
    return -1 * ESCAPE_X <= x <= ZONE_ONE_RIGHT_X
end

function inzonetwo(x::Float64)::Bool
    return ZONE_ONE_RIGHT_X < x <= ZONE_TWO_RIGHT_X
end

function inzonethree(x::Float64)::Bool
    return ZONE_TWO_RIGHT_X < x <= ZONE_THREE_RIGHT_X
end

function inzonefour(x::Float64)::Bool
    return ZONE_THREE_RIGHT_X < x <= ESCAPE_X
end

function adjustxy(xy::Array{Float64,1})
    copyxy = copy(xy)
    x = xy[1]
    if inzoneone(x)
        return copyxy, "no adjust"
    elseif inzonetwo(x)
        copyxy[1] -= SENSOR_SECOND_LEFT_X
        return copyxy, "second"
    elseif inzonethree(x)
        copyxy[1] -= SENSOR_THIRD_LEFT_X
        return copyxy, "third"
    elseif inzonefour(x)
        copyxy[1] -= SENSOR_FOURTH_LEFT_X
        return copyxy, "fourth"
    else
        println("adjust error")
    end
end

function revertxy(xy::Array{Float64}, whichsensor::String)
    copyxy = copy(xy)
    if whichsensor == "no adjust"
        return xy
    elseif whichsensor == "second"
        copyxy[1] += SENSOR_SECOND_LEFT_X
        return copyxy
    elseif whichsensor == "third"
        copyxy[1] += SENSOR_THIRD_LEFT_X
        return copyxy
    elseif whichsensor == "fourth"
        copyxy[1] += SENSOR_FOURTH_LEFT_X
        return copyxy
    else
        println("revert error")
    end
end

"Assume inputs already adjusted"
function inwater(adjustedxy::Array{Float64,1})::Bool
    x, y = adjustedxy
    left_enz = x < ENZYME_LEFT_X
    right_enz = x > ENZYME_RIGHT_X
    above_enz = y > ENZYME_MAX_Y
    return left_enz || right_enz || above_enz
end

function inenz(adjustedxy::Array{Float64,1})::Bool
    x, y = adjustedxy
    left_ppd = ENZYME_LEFT_X <= x < PPD_LEFT_X && WALL_Y < y <= ENZYME_MAX_Y
    right_ppd = PPD_RIGHT_X < x <= ENZYME_RIGHT_X && WALL_Y < y <= ENZYME_MAX_Y
    above_ppd = ENZYME_LEFT_X <= x <= ENZYME_RIGHT_X && PPD_MAX_Y < y <= ENZYME_MAX_Y
    return left_ppd || right_ppd || above_ppd
end

function inppd(adjustedxy::Array{Float64, 1})::Bool
    x, y = adjustedxy
    withinx = PPD_LEFT_X <= x <= PPD_RIGHT_X
    withiny = PPD_MIN_Y < y <= PPD_MAX_Y
    return withinx && withiny
end

"Assumed no flow in Quinto"
function flow_arlett(xy::Array{Float64,1})
    return 0.0
end


"""
    spawnrandompoint(ranfloat, randfloat) -> Array{Float64,1}

Initialize an [x,y] coordinate, uniformly random at water-enz interface, just inside enz.
"""
function spawnrandompoint(randfloat::Float64=rand(), randfloatstub::Float64=rand())
    spawncoordinate = SPAWN_LENGTH * randfloat + ENZYME_LEFT_X - SPAWN_ENZYME_MAX_Y
    if SPAWN_LEFT_X <= spawncoordinate <= SPAWN_RIGHT_X
        return [spawncoordinate, SPAWN_ENZYME_MAX_Y]
    elseif randfloat <= 0.5
        return [SPAWN_LEFT_X, SPAWN_LENGTH * randfloat]
    else
        return [SPAWN_RIGHT_X, SPAWN_LENGTH * (1 - randfloat)]
    end
end

"""
    whereoutsideenz(xy)

Assign a cardinal direction (W, NW, N, NE, or E) when crossing the water-enzyme boundary
"""
function whereoutsideenz(xy::Array{Float64,1})
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
        return "whereoutsideenz Error"
    end
end

"""
    whereoutsideppd(xy)

Assign a cardinal direction (W, NW, N, NE, or E) when crossing the enzyme-ppd boundary
"""
function whereoutsideppd(xy::Array{Float64,1})
    x, y = xy
    if x < PPD_LEFT_X
        if y > PPD_MAX_Y
            return "NW"
        else
            return "W"
        end
    elseif x > PPD_RIGHT_X
        if y > PPD_MAX_Y
            return "NE"
        else
            return "E"
        end
    elseif y > PPD_MAX_Y
        return "N"
    else
        return "whereoutsideppd Error"
    end
end
