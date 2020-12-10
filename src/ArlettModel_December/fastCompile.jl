using Random

"Simulation Controls"
NUMBER_OF_WALKS = 100
MAX_STEPS_PER_WALK = 3*1485604
FLOW_OFF = false

"Sensor/Walls Coordinates"
sensorHalfWidth = 0.5 * 25
sensorSpacing = 20
sensorCenterMaxX = sensorHalfWidth
sensorInnerAdjMinX = sensorHalfWidth + sensorSpacing
sensorInnerAdjMaxX = 3 * sensorHalfWidth + sensorSpacing
sensorOuterAdjMinX = 3 * sensorHalfWidth + 2 * sensorSpacing
sensorOuterAdjMaxX = 5 * sensorHalfWidth + 2 * sensorSpacing

"PPD Layer Dimensions"
ppdMaxY = 0.15
ppdMinY = 0

"Enzymatic Layer Dimensions"
enzymaticLeftX = -13.5
enzymaticRightX = 13.5
wallY = 1.5
enzymeMaxYFromWall = 0.15
enzymeMaxY = wallY + enzymeMaxYFromWall

"Spawn Inside Enzymatic Layer"
spawnLineLength = enzymaticRightX - enzymaticLeftX + 2 * enzymeMaxYFromWall
borderCorrection = 0.001
spawnLeftX = enzymaticLeftX + borderCorrection
spawnRightX = enzymaticRightX - borderCorrection
spawnEnzymeMaxY = enzymeMaxY - borderCorrection

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
waterStepSize = 0.1
enzStepSize = 0.005
ppdStepSize = 0.0007
stepSizeDict = Dict("water" => 0.1, "enz" => 0.005, "ppd" => 0.0007)

"Escape Bound Limits"
escapeX = 5 * sensorHalfWidth + 2.5 * sensorSpacing
escapeY = escapeX

"Safe Bound Limits"
marginOfCollision = 5 * stepSizeDict["water"]
safeMinY = enzymeMaxY + marginOfCollision
safeMaxY = escapeY - marginOfCollision
safeMaxX = escapeX - marginOfCollision

"Spawning above walls for overflowing enzymatic layer"
function spawnRandomPoint()
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

"Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector"
function sensWall(initXY, dx, dy, stepSize)
    x, y = initXY
    newX = x + stepSize*dx
    newY = y + stepSize*dy

    if inWalls(newX, newY)
        return sensWall(initXY, dx, dy, stepSize * 0.5)
    else
        return [newX, newY]
    end
end

"At horizontal boundary between water-enzymatic, water-ppd, or ppd-enzymatic"
function North(previous, proposed, dx, dy, start, endup)
    initX, initY = previous
    scale = stepSizeDict[start]
    scale2 = stepSizeDict[endup]
    slope = (proposed[1] - initX) / (proposed[2] - initY)           # Reciprocal of traditional slope (delta x over delta y)

    if start == "ppd" || endup == "ppd"
        yIntersection = ppdMaxY
    else
        yIntersection = enzymeMaxY
    end

    xIntersection = slope * (yIntersection - initY) + initX         # x-component of the head of first segment, ending at the border crossing
                # Reciprocal slope lets us multiply the change in y to obtain the change in x
    yDistLeft = scale * dy + (initY - yIntersection)                # y-component legnth of the original second segment
    xDistLeft = scale * dx + (initX - xIntersection)                # x-component length of the original second segment
    new_proposed = [xIntersection + xDistLeft * scale2/scale, yIntersection + yDistLeft * scale2/scale]
                # First divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
                # Then multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
                # Lastly append the correct lengths of the new second segment to the head of the first segment vector
    return new_proposed
end

"At vertical boundary between enzyme and water. No ppd-water vertical boundary, only ppd-wall"
function EastWest(previous, proposed, dx, dy, start, endup, EastOrWest)
    initX, initY = previous
    propX, propY = proposed
    scale = stepSizeDict[start]
    scale2 = stepSizeDict[endup]
    slope = (propY - initY) / (propX - initX)           # Traditional slope (delta y over delta x)

    if EastOrWest == "E"
        xIntersection = enzymaticRightX
    else
        xIntersection = enzymaticLeftX
    end

    yIntersection = slope * (xIntersection - initX) + initY         # y-component of the head of first segment, ending at the border crossing
                # Multiply the slope and the change in y to obtain the change in x
    xDistLeft = scale * dx + (initX - xIntersection)                # x-component legnth of the original second segment
    yDistLeft = scale * dy + (initY - yIntersection)                # y-component legnth of the original second segment
    new_proposed = [xIntersection + xDistLeft * scale2/scale, yIntersection + yDistLeft * scale2/scale]
                # Divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
                # Multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
                # Append the correct lengths of the new second segment to the head of the first segment vector
    return new_proposed
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

function inEscapeBounds(x_val, y_val)
    withinX = abs(x_val) <= escapeX
    withinY = -1 <= y_val <= escapeY
    return withinX && withinY
end

"true when inside parylene walls"
function inWalls(x_val, y_val)
    withinX = !inCenterX(x_val) && !inInnerAdjX(x_val) && !inOuterAdjX(x_val)
    withinY = y_val <= wallY
    return withinX && withinY
end

function inOverflowEnz(x_val, y_val)
    withinX = enzymaticLeftX <= x_val <= enzymaticRightX
    withinY = wallY < y_val <= enzymeMaxY
    return withinX && withinY
end

function inCenterX(x_val)
    return abs(x_val) < sensorCenterMaxX
end

function inInnerAdjX(x_val)
    return sensorInnerAdjMinX < abs(x_val) < sensorInnerAdjMaxX
end

function inOuterAdjX(x_val)
    return sensorOuterAdjMinX < abs(x_val) < sensorOuterAdjMaxX
end

function inSensor(xyCoord)
    y = xyCoord[2]
    return y <= 0
end

"true when outside sensors ppd and enzymatic layers"
function inWater(xyCoord)
    x, y = xyCoord
    inAdjWellWater = ppdMaxY < y <= wallY && inInnerAdjX(x) || inOuterAdjX(x)
    inWaterAboveWalls = y > wallY && inEscapeBounds(x, y) && !inOverflowEnz(x, y)
    return inAdjWellWater || inWaterAboveWalls
end

function inEnz(xyCoord)
    x, y = xyCoord
    if ppdMaxY < y <= wallY
        return inCenterX(x)
    else
        return inOverflowEnz(x, y)
    end
end

"true when inside the 150 nm thick layer of m-phenylendiamine (PPD) on each sensor pads"
function inPPD(xyCoord)
    x,y = xyCoord
    inPPDX = inCenterX(x) || inInnerAdjX(x) || inOuterAdjX(x)
    inPPDY = ppdMinY < y <= ppdMaxY
    return inPPDX && inPPDY
end

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

"Manages steplength calculations and adjusts the steplength by layers accordingly."
function calculateProposedPoint(initialXY, dx, dy)
    if inWater(initialXY)
        return waterCalc(initialXY, dx, dy)
    elseif inEnz(initialXY)
        return enzCalc(initialXY, dx, dy)
    elseif inPPD(initialXY)
        return ppdCalc(initialXY, dx, dy)
    else
        println("calcPropPoint Error", initialXY)
        return undef, 0
    end
end

function waterCalc(initialXY, dx, dy)
    initX, initY = initialXY
    flowBias = flow(initialXY)
    proposedXY = [initX + flowBias + waterStepSize * dx, initY + waterStepSize * dy]

    if inWater(proposedXY)
        return proposedXY, "water"
    elseif inEnz(proposedXY)
        directionOfEntry = whereOutsideSpawn(initialXY) # tail in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in waterCalc ", initialXY, proposedXY)
        elseif directionOfEntry == "N"
            confirmXY = North(initialXY, proposedXY, dx, dy, "water", "enz")
        elseif directionOfEntry == "NE"
            cornerCut = 0.5 * enzStepSize
            confirmXY = [enzymaticRightX - cornerCut, enzymeMaxY - cornerCut]
        elseif directionOfEntry == "NW"
            cornerCut = 0.5 * enzStepSize
            confirmXY = [enzymaticLeftX + cornerCut, enzymeMaxY - cornerCut]
        else # E or W
            confirmXY = EastWest(initialXY, proposedXY, dx, dy, "water", "enz", directionOfEntry)
        end
        return confirmXY, "enz"
    elseif inPPD(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "water", "ppd")
        return confirmXY, "ppd"
    else # collision
        return proposedXY, "water"
    end
end

function enzCalc(initialXY, dx, dy)
    initX, initY = initialXY
    flowBias = flow(initialXY) * enzStepSize / waterStepSize
    proposedXY = [initX + flowBias + enzStepSize * dx, initY + enzStepSize * dy]

    if inEnz(proposedXY)
        return proposedXY, "enz"
    elseif inWater(proposedXY)
        directionOfEntry = whereOutsideSpawn(proposedXY) # head in water
        if directionOfEntry == "whereOutsideSpawn Error"
            println(directionOfEntry, " in enzCalc ", initialXY, proposedXY)
        elseif directionOfEntry == "N"
            confirmXY = North(initialXY, proposedXY, dx, dy, "enz", "water")
        elseif directionOfEntry == "NE"
            cornerCut = 0.5 * waterStepSize
            confirmXY = [enzymaticLeftX - cornerCut, enzymeMaxY + cornerCut]
        elseif directionOfEntry == "NW"
            cornerCut = 0.5 * waterStepSize
            confirmXY = [enzymaticRightX + cornerCut, enzymeMaxY + cornerCut]
        else # E or W
            confirmXY = EastWest(initialXY, proposedXY, dx, dy, "enz", "water", directionOfEntry)
        end
        return confirmXY, "water"
    elseif inPPD(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "enz", "ppd")
        return confirmXY, "ppd"
    else # collision
        return proposedXY, "enz"
    end
end

function ppdCalc(initialXY, dx, dy)
    initX, initY = initialXY
    proposedXY = [initX + ppdStepSize * dx, initY + ppdStepSize * dy] # no flow

    if inPPD(proposedXY)
        return proposedXY, "ppd"
    elseif inEnz(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "ppd", "enz")
        return confirmXY, "enz"
    elseif inWater(proposedXY)
        confirmXY = North(initialXY, proposedXY, dx, dy, "ppd", "water")
        return confirmXY, "water"
    else # collision
        return proposedXY, "ppd"
    end
end

function boundaryCheck(initialXY, dx, dy)
    proposedXY, endingLayer = calculateProposedPoint(initialXY, dx, dy)
    initX, initY = initialXY
    propX, propY = proposedXY
    endingStepSize = stepSizeDict[ endingLayer ]

    if !inEscapeBounds(propX, propY)    # before wall for corner case
        return undef, "escape"
    elseif inSensor(proposedXY)
        return undef, sensorCases(initX)
    elseif inWalls(propX, propY)
        return sensWall(initialXY, dx, dy, endingStepSize), wallCases(initialXY)
    else
        return proposedXY, "no collision"
    end
end

function sensorCases(initX)
    if inCenterX(initX)
        return "center sensor"
    elseif initX < 0
        position = "left"
    else
        position = "right"
    end

    if inInnerAdjX(initX)
        return position * " inner sensor"
    elseif inOuterAdjX(initX)
        return position * " outer sensor"
    else
        println("sensorCases error ", initX)
        return "sensorCases error"
    end
end

function wallCases(initialXY)
    initX, initY = initialXY
    if initY <= wallY
        return "side wall"
    elseif initY > wallY && (!inCenterX(initX) || !inInnerAdjX(initX) || !inOuterAdjX(initX))
        return "top wall"
    else
        cornerCase = Dict(0 => "side wall", 1 => "top wall")
        return cornerCase[bitrand()[1]] # coinflip rare ambiguous case
    end
end

function oneStep(initialXY)
    theta = -1*pi + 2*pi*rand(Float64)  # -pi to pi
    dx = cos(theta)
    dy = sin(theta)

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
    withinY = safeMinY < y_val < safeMaxY
    return withinX && withinY
end

function fullCollisionData2()
    println("Arlett Model: Walls + Overflow Spawn + 1 Thick Enzymatic + 5 PPD + Flow")
    println("Particles: $NUMBER_OF_WALKS \t  Steps: $MAX_STEPS_PER_WALK\t Step lengths: $stepSizeDict")

    data = Dict{String,Integer}()
    data["side wall"] = 0
    data["top wall"] = 0
    data["escape"] = 0

    data["left outer sensor"] = 0
    data["left inner sensor"] = 0
    data["center sensor"] = 0
    data["right inner sensor"] = 0
    data["right outer sensor"] = 0

    data["particles unresolved"] = 0

    for _ in 1:NUMBER_OF_WALKS
        peroxideXY = spawnRandomPoint()
        index = 0
        while peroxideXY != undef && index < MAX_STEPS_PER_WALK
            peroxideXY, collision = oneStep(peroxideXY)
            if collision != "no collision"
                data[collision] += 1
            end
            index += 1
        end

        if index >= MAX_STEPS_PER_WALK
            data["particles unresolved"] += 1
        end
    end
    # present data in command line
    for keyVal in data
        extraSpacing = ""
        if length(keyVal[1]) < 14
            multiplier = 13 ÷ length(keyVal[1])
            extraSpacing = repeat("\t", multiplier)
        end
        println(keyVal[1], "\t", extraSpacing, keyVal[2])
    end
end
