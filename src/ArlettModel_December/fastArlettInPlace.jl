# Random Walk 7:  Walls + Overflow Spawn + 1 Thick Enzymatic + 5 PPD
# Filename: i_Arlett.jl
# Author(s): Sean Wu, co-developing code with Sonali Madisetti
# Last Updated: August 4, 2020

using Printf    # for all your println neexds working in base Julia
using Random    # random number generator in Julia, based on MersenneTwister objects. Comparable to Random and numpy.random packages in Python.

# All coordinate and length values are in micrometers (um).

function spawnRandomPoint()
    """
        Creates one [float, float] xy coordinate located just within the top rim of central Sensor 3's enzymatic layer, the spawn location of one hydrogen peroxide molecule
        when some aqueous target chemical reacts with the functionalized enzymatic layer the instant before the start of the individual simulation run.
    """
    l = 27.3 * rand(Float64)                #Spawn 32-bit float in [0, 27.3)
    if l < 0.15                             #Left Enzyme Side   l in [0, 0.15)
        x0 = -13.499                            # x coordinate just right of enzyme-water border
        y0 = 1.5 + l                            # y coord in [1.5, 1.65)
    elseif l <= 27.15                       #Top Enzyme Face    l in [0.15, 27.15]
        x0 = l - 0.15 - 13.5                    # x coord in [-13.5, 13.5]
        y0 = 1.6499                             # y coord just under enz-water border
    else                                    #Right Enzyme Side  l in (27.15, 27.3)
        x0 = 13.499                             # x coord just left of enz-water border
        y0 = 1.5 + l - 27.15                    # y coord in (1.5, 1.65)
    end
    return [x0, y0]                         # xy coordinates constructed as a vector in a 1x2 Array
end

function sensWall(initPoint, dx, dy, barrier)
    """
        Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector
        in half (by shrinking the unit vector) until the proposed vector lands outside of the walls.

        initPoint   the initial point, the tail of the proposed vector
        dx, dy      the x- and y-components of the unit vector
        barrier     either outside, enzyme, ppd (float variable), scales the unit vector to the proposed vector based which layer initPoint resides in

        new         returns the shortened proposed vector to function calculateProposedPoint
    """
    new = [initPoint[1] + barrier*dx, initPoint[2] + barrier*dy]        # Compute the shortened proposed vector
    absNew = abs(new[1])
    if new[2] <= 1.5                                                        # Verify point below top wall height
        if absNew >= 12.5 && absNew <= 32.5                                 # Check pair of walls adjacent to center sensor
            return sensWall(initPoint, dx/2, dy/2, barrier)
        elseif absNew >= 57.5 && absNew <= 77.5                             # Checks pair of walls between closer and further pairs of neighboring sensors
            return sensWall(initPoint, dx/2, dy/2, barrier)
        elseif absNew >= 102.5                                              # Checks pair of  walls between further pair of neighboring sensors and escape bound
            return sensWall(initPoint, dx/2, dy/2, barrier)
        else
            return new                                                  # Satisfactory shortened proposed vector, lands in well
        end
    else
        return new                                                      # Satisfactory shortened proposed vector, lands above wall/well
    end
end

function scaling(outside, enzyme, ppd, start, endup)
    """
        Determines scaling values for the two segments of any proposed vector that crosses the border dividing water, enzymatic, or ppd layers.

        outside, enzyme, ppd    the float variable steplengths of water, enzymatic, and ppd layers (unpacked global LAYERS in function calculateProposedPoint)
        start, endup            the String variables noting which layers the molecule travels from and to across the layer border (assigned in function calculateProposedPoint)

        scale, scale2           returns the assigned steplengths to functions North and EastWest
    """
    if start == "ppd"           # Assigns the original layer steplength by checking start with conditional statements
        scale = ppd
    elseif start == "enz"
        scale = enzyme
    else #start == 'outside'
        scale = outside
    end

    if endup == "ppd"           # Assigns the original layer steplength by checking start with conditional statements
        scale2 = ppd
    elseif endup == "enz"
        scale2 = enzyme
    else #endup == 'outside
        scale2 = outside
    end
    return scale, scale2
end

function North(previous, proposed, outside, enzyme, ppd, dx, dy, start, endup)
    """
        Correctly scales any proposed vector that crosses the horizontal borders dividing the water-enzymatic or enzympatic-ppd layers.

        previous, proposed      [float, float] variables: the xy coordinates of the head and tail of the original proposed vector
        outside, enzyme, ppd    float variable steplengths of water, enzymatic, and ppd layers (passed to function scaling)
        dx, dy                  full unit vectors of the proposed vector
        start, endup            String variables noting which layers the molecule travels from and to across the layer border (passed to function scaling)

        new_proposed             returns the correctly scaled proposed vector to function calculateProposedPoint
    """
    initX, initY = previous
    slope = (proposed[1] - initX) / (proposed[2] - initY)           # Reciprocal of traditional slope (delta x over delta y)
    if start == "ppd" || endup == "ppd"     # Horizontal border between top of ppd layer(s) and bottom of enzymatic layer(s)
        yIntersection = 0.15
    else                                    # Horizontal border between top enzymatic layer(s) and bottom of ppd layer(s)
        yIntersection = 1.65                # y-component of the head of first segment, ending at the border crossing
    end
    xIntersection = slope * (yIntersection - initY) + initX         # x-component of the head of first segment, ending at the border crossing
                # Reciprocal slope lets us multiply the change in y to obtain the change in x
    scale, scale2 = scaling(outside, enzyme, ppd, start, endup)     # scale and scale2 for the original and new segment of the proposed vector
    yDistLeft = scale * dy + (initY - yIntersection)                # y-component legnth of the original second segment
    xDistLeft = scale * dx + (initX - xIntersection)                # x-component length of the original second segment
    new_proposed = [xIntersection + xDistLeft * scale2/scale, yIntersection + yDistLeft * scale2/scale]
                # First divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
                # Then multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
                # Lastly append the correct lengths of the new second segment to the head of the first segment vector
    return new_proposed
end

function EastWest(previous, proposed, outside, enzyme, ppd, dx, dy, start, endup, EastOrWest)
    """
        Correctly scales any proposed vector that crosses the vertical borders dividing the water-enzymatic layers.

        previous, proposed      [float, float] variables: the xy coordinates of the tail and head of the original proposed vector
        outside, enzyme, ppd    float variable steplengths of water, enzymatic, and ppd layers (passed to function scaling)
        dx, dy                  full unit vectors of the proposed vector
        start, endup            String variables noting which layers the molecule travels from and to across the layer border (passed to function scaling)
        EastOrWest              String "W" or "E" noting the left or right side of enzymatic layer

        new_proposed            returns the correctly scaled proposed vector to function calculateProposedPoint
    """
    initX, initY = previous
    slope = (proposed[2] - initY) / (proposed[1] - initX)           # Traditional slope (delta y over delta x)

    if EastOrWest == "E"            # Vertical border between water and right of enzymatic layer
        xIntersection = 13.5
    else                            # Vertical border between water and left of enzymatic layer
        xIntersection = -13.5   # x-component of the head of first segment, ending at the border crossing
    end
    yIntersection = slope * (xIntersection - initX) + initY         # y-component of the head of first segment, ending at the border crossing
                # Multiply the slope and the change in y to obtain the change in x

                scale, scale2 = scaling(outside, enzyme, ppd, start, endup)     # scale and scale2 for the original and new segment of the proposed vector
    xDistLeft = scale * dx + (initX - xIntersection)                # x-component legnth of the original second segment
    yDistLeft = scale * dy + (initY - yIntersection)                # y-component legnth of the original second segment
    new_proposed = [xIntersection + xDistLeft * scale2/scale, yIntersection + yDistLeft * scale2/scale]
                # Divide the x- and y- component lengths of the original segment steplength, scale -> recover the unit vector length of second segment
                # Multiply the x- and y-components of the unit vector length of  second semester by scale2 -> obtain correct length of the second segment in new layer
                # Append the correct lengths of the new second segment to the head of the first segment vector
    return new_proposed
end

function whereOutside(point)
    """
        Assigns a molecule to the closest one of five cardinal directions at the water-enzyme border

        point   [float, float] variables, the xy coordinates of the hydrogen peroxide molecule

        d       String cardinal direction East, Northeast, North, Northwest, and West. Returned to function calculateProposedPoint.
    """
    initX, initY = point
    d = ""              #Initialize
    if initX < -13.5                        # Check if left of enzymatic layer
        if initY > 1.65                         # Check if above top of enz layer   (left above = Northwest)
            d = "NW"
        else                                    # Below top of enz layer            (left = West)
            d = "W"
        end
    elseif initX > 13.5                     # Check if right of enzymatic layer
        if initY > 1.65                         # Check if above top of enz layer   (right above = Northeast)
            d = "NE"
        else                                    # Below top of enz layer            (right = East)
            d = "E"
        end
    elseif initY > 1.65                     # Check if above top of enz layer
        d = "N"                                 # (above = North)
    else
        println("whereOutside Error")
    end
    return d
end

function inPPD(point)
    """
        point       [float, float] variables, the xy coordinates of the hydrogen peroxide molecule
        True/False  returns boolean whether molecule is/is not inside the 150 nm thick layer of m-phenylendiamine (PPD) on each of the five electrochemical sensor pads.
    """
    absX = abs(point[1])
    if point[2] <= 0.15 && point[2] > 0         # Verify y-coordinate is in (0, 0.15]
        if absX < 12.5                              # Verify x-coordinate is in Sensor 3 (-12.5, 12.5)
            return true
        elseif absX > 32.5 && absX < 57.5           # or x-coor in Sensor 2 (-57.5, -32.5) or Sensor 4 (32.5, 57.5)
            return true
        elseif absX > 77.5 && absX < 102.5          # or x-coor in Sensor 1 (-102.5, -77.5) or Sensor 5 (77.5, 102.5)
            return true
        else
            return false                        # Otherwise, false
        end
    else
        return false
    end
end

function inEnz(point)
    """
        point       [float, float] variables, the xy coordinates of the hydrogen peroxide molecule
        True/False  returns boolean whether molecule is/is not inside the 1.5 um thick layer of enzymatic-gluteraldehyde layer on each of the five electrochemical sensor pads.
    """
    if point[2] <= 1.65 && point[2] > 1.5       # Verify y-coordinate is in the overflow region of the enzymatic layer, above the wall (1.5, 1.65]
        if abs(point[1]) < 13.5                     # Verfiy x-coordinate is in the wider overflow region on central Sensor 3 (-13.5, 13.5)
            return true
        else
            return false                            # Otherwise, false
        end
    elseif point[2] <= 1.5 && point[2] > 0.15   # Verify y-coordinate is in the well region of the enzymatic layer (0.15, 1.5]
        if abs(point[1]) < 12.5                     # Verify x-coordinate is in the narrower well region of enz on the central Sensor 3 (-12.5, 12.5)
            return true
        else
            return false                            # Otherwise, false
        end
    else
        return false
    end
end

function inWater(point)
    """
        point       [float, float] variables, the xy coordinates of the hydrogen peroxide molecule
        True/False  returns boolean whether molecule is/is not floating freely above and around the enzymatic/ppd layers, within the escape boundary.
    """
    absX = abs(point[1])
    y = point[2]
    if y < 112.5 && absX < 112.5                # Verify if xy coordinates are within the escape boundary (right of x = -112.5, left of x = 112.5, below y = 112.5)
        if y > 1.65                                 # With no layers above y = 1.65 (enzymatic tapers at y = 1.65 inclusive), guaranteed to be in Water
            return true
        elseif y > 1.5 && absX > 13.5               # Above the walls, verify molecule is not in the overflow region of the central enzymatic layer
            return true
        elseif y > 0.15 && y < 1.5                  # Inside the wells
            if absX > 32.5 && absX < 57.5               # Verfiy x-coordinate is in Sensor 2 (-57.5, -32.5) or Sensor 4 (32.5, 57.5)
                return true
            elseif absX > 77.5 && absX < 102.5          # or x-coor in Sensor 1 (-102.5, -77.5) or Sensor 5 (77.5, 102.5)
                return true
            else
                return false
            end
        else                                    # Otherwise, false
            return false
        end
    else
        return false
    end
end

function flow(previous)
    """
        Effective diffusion calculated by the flow rate of 700 mL/40s through a channel w/ 0.21 in. by 0.1 in. rectangular cross section,
        creating a small vector bias with y-dependent magnitude and +x direction (to the right)

        previous    [float, float] the xy coordinates of the original point, where the tail of the proposed vector begins
        bias        small nudge that shifts the proposed point to the right
    """
    speed = 6327*(1 - ((1270 - previous[2])^2) / (1270^2))  # For simplicity, use the previous y-coordinate, doesn't differ from proposed enough to significantly change flow bias.
    tau = 0.0000027077
    bias = speed*tau
    return bias
end

function calculateProposedPoint(previous, layers, dx, dy)
    """
        Manages steplength calculations and adjusts the steplength by layers accordingly.
        For border-crossings between layers, accurate up to 2 layers at the beginning and end. Not comprehensive to the rare corner cases involving intermediate layers,
        such as water-enzymatic-water or enzymatic-ppd-wall. (Why? Cost-benefit of accuracy vs complexity/runtime decided not worthwhile due to rare occurence).
        The corners of the enzymatic-water borders are also approximated.
        Disregards wall collisions (hence a proposal only), but resolved and confirmed later by function BoundaryCheck.

        previous    [float, float] the xy coordinates of the original point, where the tail of the proposed vector begins
        layers      [float, float, float] from the global variable LAYERS, the array of steplengths of water, enzymatic, and ppd layers
        dx, dy      unit vectors of the preliminary proposed vector as decided by the random theta in function oneStep

        proposed    [float, float] the xy coordinates of proposed point, where the head of the proposed vector ends; the destination
        barrier     float steplength of the layer at the proposed point (passed to function sensWall)
    """
    #Initializing
    initX, initY = previous
    outside, enzyme, ppd = layers   # Unpack the float steplengths, used to calculate proposed and pass to North, EastWEst,
    proposed = undef                # Initialize proposed variable. Always changed unless previous is not among the 3 layers (impossible unless previous = undef)
    barrier = 0                     # Initialize barrier steplength. If barreir = 0 persists to the end, then previous != undef and proposed == undef, predicting a collision

    if previous[2] > 1.5 # Flow happens above wall
        nudge = flow(previous)
    else
        nudge = 0
    end

    # FLOW CHART: Layer of previous -> calculate proposed -> Layer of proposed
    if inWater(previous)
        proposed = [initX + nudge + outside * dx, initY + outside * dy]
        if inWater(proposed)                                            # Water => Water
            barrier = outside
        elseif inEnz(proposed)                                          # Water => Enzymatic, a border crossing
            initLoc = whereOutside(previous)                                # Determine the cardinal direction of border crossing using previous
            barrier = enzyme
            if initLoc == "N"
                proposed = North(previous, proposed, outside, enzyme, ppd, dx, dy, "outside", "enz")
            elseif initLoc == "NE"                                          # Northeast and Northwest are approximated corner cases, as top or side face assignment is complex
                hop = 0.5 * enzyme
                proposed = [13.5 - hop, 1.65 - hop]                    # For Northeast, molecule tucked inside (left and below) the top right corner of the enzymatic layer
            elseif initLoc == "NW"
                hop = 0.5 * enzyme
                proposed = [-13.5 + hop, 1.65 - hop]                    # For Northwest, molecule tucked inside (right and below) the top left corner of the enzymatic layer
            else #initLoc is 'E' or 'W'
                proposed = EastWest(previous, proposed, outside, enzyme, ppd, dx, dy, "outside", "enz", initLoc)
            end
        elseif inPPD(proposed)                                          # Water => PPD
            proposed = North(previous, proposed, outside, enzyme, ppd, dx, dy, "outisde", "ppd")
            barrier = ppd
        # No else statement, this happens when peroxide will annihilate in boundaryCheck(proposed), predicting an escape/topwall collision, barrier=0
        end
    elseif inEnz(previous)
        proposed = [initX + enzyme * dx, initY + enzyme * dy]
        if inEnz(proposed)                                              # Enzymatic => Enzymatic
            barrier = enzyme
        elseif inWater(proposed)                                        # Enzymatic => Water
            nextLoc = whereOutside(proposed)                                # Determine the cardinal direction of border crossing, reusing code by analyzing the proposed instead of previous
            barrier = outside
            if nextLoc == "N"
                proposed = North(previous, proposed, outside, enzyme, ppd, dx, dy, "enz", "outside")
            elseif nextLoc == "NW"                                          # Northeast and Northwest are approximated corner cases, as top or side face assignment is complex
                hop = 0.5 * outside
                proposed = [-13.5 - hop, 1.65 + hop]                        # For Northwest, molecule tucked outside (right and above) the top left corner of the enzymatic layer
            elseif nextLoc == "NE"
                hop = 0.5 * outside
                proposed = [13.5 + hop, 1.65 + hop]                        # For Northeast, molecule tucked outside (left and above) the top right corner of the enzymatic layer
            else # nextLoc is 'E' or 'W'
                proposed = EastWest(previous, proposed, outside, enzyme, ppd, dx, dy, "enz", "outside", nextLoc)
            end
        elseif inPPD(proposed)                                          # Enzymatic => PPD
            proposed = North(previous, proposed, outside, enzyme, ppd, dx, dy, "enz", "ppd")
            barrier = ppd
        # No else statement, predicting a topwall or sidewall collision, barrier=0
        end
    elseif inPPD(previous)
        proposed = [initX + ppd * dx, initY + ppd * dy]
        if inPPD(proposed)                                              # PPD => PPD
            barrier = ppd
        elseif inEnz(proposed)                                          # PPD => Enzymatic
            proposed = North(previous, proposed, outside, enzyme, ppd, dx, dy, "ppd", "enz")
            barrier = enzyme
        elseif inWater(proposed)                                        # PPD => Water
            proposed =  North(previous, proposed, outside, enzyme, ppd, dx, dy, "ppd", "outside")
            barrier = outside
        # No else statement, this happens when peroxide will annihilate in boundaryCheck(proposed), predicting a sensor/sidewall collision, barrier=0
        end
    else
        print("calcPropPoint Error", previous, proposed)
    end
    return proposed, barrier
end

function boundaryCheck(previous, layers, dx, dy)
    """
        Determines if and tallies when a point enters a sensor, collides with a wall, or travels out of the escape boundary (these events herein called collisions).
        If so, then the proposed point is obliterated (= undef) or adjusted according to these collisions.

        previous        [float, float] the xy coordinates of the original point, where the tail of the proposed vector will begin
        layers          [float, float, float] from the global variable LAYERS, the array of steplengths of water, enzymatic, and ppd layers
        dx, dy          unit vectors of the preliminary proposed vector as decided by the random theta in function oneStep

        confirm         [float, float] the finalized xy coordinates that the molecule will diffuse to in this timestep
        wallType        Integer representing the type of collision (see wallType key below), used as a convenient index for newTally
    """
    initX, initY = previous
    proposed, barrier = calculateProposedPoint(previous, layers, dx, dy)    # proposed point coordinate that accounts for step length (changes too)
    confirm = undef                     # Default annihilation (in most collision cases for brevity), recovered to confirm = proposed if no collision occurs
    wallType = 9                        # wallType = 8 represents no collision, tallied to newTally for indexing convenience (reset per molecule), not in finalTally
    err = 0.1                           # Widens the sensor detect range so that corner cases at the sensor are covered
    xf = proposed[1]
    absX = abs(xf)

    # wallType key: 1-Side, 2-Top, 3-Leftmost, 4-Left, 5-Center, 6-Right, 7-Rightmost, 8-escape, 9-undef
    if proposed[2] <= 0 #ALL SENSOR CASES HANDLED HERE
        if xf > -102.5 - err && xf < -77.5 + err            # SENSOR 1 (leftmost)
            wallType = 3
        elseif xf > -57.5 - err && xf < -32.5 + err         # SENSOR 2 (left)
            wallType = 4
        elseif absX < 12.5 + err                            # SENSOR 3 (center)
            wallType = 5
        elseif xf > 32.5 - err && xf < 57.5 + err           # SENSOR 4 (right)
            wallType = 6
        elseif xf > 77.5 - err && xf < 102.5 + err          # SENSOR 5 (rightmost)
            wallType = 7
        else
            println("Sensor Error\t initial ", previous, "\t proposed", proposed )
        end
        # ALL PARYLENE WALL CASES HANDLED HERE BELOW
    elseif proposed[2] <= 1.5 && ((absX >= 12.5 && absX <= 32.5) || (absX >= 57.5 && absX <= 77.5) || (absX >= 102.5))
                                                        # Verify proposed/head inside walls, y-coor of head below wall height 1.5 and x-coor between sensors
        if initY <= 1.5                                 # SIDE WALL collision, guaranteed if previous/tail begins in well (y-coor below wall height 1.5)
            wallType = 1
            confirm = sensWall(previous, dx/2, dy/2, barrier)       # Sidewall always resolves collisions
        elseif (abs(initX) >= 12.5 && abs(initX) <= 32.5) || (abs(initX) >= 57.5 && abs(initX) <= 77.5) || (abs(initX) >= 102.5)
                                                        # Verify **tail** between sensors (x-coor) and above walls (y-coor)
            wallType = 2                                # TOP WALL collision, guaranteed if tail is between sensors and above walls
        else
            if bitrand()[1] > 0                         # Corner case (x-coor in sensor region, y-coor above wall height) too complex, use coinflip. bitrand() is randomly 0 or 1
                wallType = 1
                confirm = sensWall(previous, dx/2, dy/2, barrier)   # Sidwall always resolves collisions
            else
                wallType = 2                            # TOP WALL collision, recovered if there is no catalase in the simulation
            end
        end
    elseif absX > 112.5 || proposed[2] >= 112.5         # ESCAPE case, verify if xy coordinates are outside the escape boundary (left of x = -112.5, right of x = 112.5, above y = 112.5)
        wallType = 8
    else    # wallType = 9
        confirm = proposed
        #= Bugfixing tests
        if barrier == 0 || proposed != undef
            println("calculateProposed predicted collision, no collision occurs", previous, "\tproposed", proposed)
        end =#
    end

    if wallType == 2    # Topwall collisions recovered separately so catalase features (probabilistic topwall peroxide annihilation) can be easily implemented here
        confirm = sensWall(previous, dx/2, dy/2, barrier)
    end

    # Bugfixing
    md = layers[1] + layers[2]  # max displacement
    if confirm != undef
        if abs(confirm[2] - previous[2]) > md || abs(confirm[1] - previous[1]) > md
            println("Step too large", previous, confirm, proposed, wallType, barrier)
        end
    end
    return confirm, wallType
end

function oneStep(previous, layers)
    """
        Generates a random angle for particle's next step. The particle is judged whether it is in an easily resolved region with no collisions/border crossing, and employs
        function boundaryCheck when more nuance and investigation may be required. This "smart" distinction expedites runtime by reducing unnecessary conditional statements.

        [initX...], 9   the xy coordinate of a simple water-water step with no collision. Dummy index 9 is returned but not included in finalTally
        boundaryCheck() returns both the confirmed xy coordinate in a collision/border crossing and the appropriate index to tally in finalTally
    """
    #Initialization
    theta = -1*pi + 2*pi*rand(Float32)  # Random number stays local, helping runtime
    dx = cos(theta)                     # Resolved here, passed to both calculateProposedPoint and sensWall
    dy = sin(theta)                     # FUTURE READER! Use accurate functions instead of faster Taylor polynomials, the slight error bias completely changes results

    initX, initY = previous
    if abs(previous[1]) < 112 && previous[2] > 2 && previous[2] < 112           # No trouble, shortcut when collisions and layer changes are not possible
        nudge = flow(previous)                                                  # No trouble region above walls, so there is flow bias
        return [initX + nudge + layers[1] * dx, initY + layers[1] * dy] , 9
    else
        return boundaryCheck(previous, layers, dx, dy)
    end
end

function RandomWalk(n, max_steps, layers)
    """
        A two-dimensional Monte Carlo simulation that models the movement of hydrogen peroxide particles (herein singularly called peroxide, particle or molecule) diffusing
        about the electrochemical sensor pads. Each particle is run indpenently, as we assume movement is determined by Brownian Motion/diffusion (and flow, if included).
        The random walk simplifies collisions with other unknown particles, so the mathematical model is concentration invariant. Particles can travel through different layers
        (water/solution, enzymatic, and m-phenylendiamine) with different diffusion constants and collide with parylene walls before reaching their destination.
        The distribution of destinations (sensor, catalase, outside) is tallied up as the output data.

        n           Integer value from the global variable PEROXIDE, the number of particles to run independently
        max_steps   Integer value from the global variable STEPS, the maximum number of steps to occur in a given step length and time interval
        layers      [float, float, float] from the global variable LAYERS, the array of steplengths of water, enzymatic, and ppd layers
    """
    finalTally = [0, 0, 0, 0, 0, 0, 0, 0]                       # Initialize the blank tally to track our data
    for _ in 1:n                                                # One iteration in the for loop for each peroxide walk
        final = spawnRandomPoint()                              # Initialize the first coordinate
        index = 0                                               # Track the number of steps taken
        while final != undef && index < max_steps               # One interation for every step, breaks loop before max_steps to avoid redunant calculations
            final, wallType = oneStep(final, layers)
            if wallType != 9                                    # 1-8 collisions, 9 is ommited (no collision, indexing convenience)
                finalTally[wallType] += 1
            end
            index += 1
        end
    end
    # for and while loop here are the only iterative pieces besides the occasional recursive loop in sensWall
    return finalTally
end

PEROXIDE = 100
STEP = 3*1485604
LAYERS = (0.1, 0.005, 0.0007)

function main()
    println("Random Walk 9: Walls + Overflow Spawn + 1 Thick Enzymatic + 5 PPD + Flow")
    println("Particles: $PEROXIDE \t  Steps: $STEP\tStep lengths: water, enzymatic, ppd = $LAYERS")
    finalTally = RandomWalk(PEROXIDE, STEP, LAYERS)
    println(finalTally)
    println("Side Wall\t\t", finalTally[1])
    println("Top Wall\t\t", finalTally[2])
    println("Leftmost Sensor\t\t", finalTally[3])
    println("Left Sensor\t\t", finalTally[4])
    println("Center Sensor\t\t", finalTally[5])
    println("Right Sensor\t\t", finalTally[6])
    println("Rtmost Sensor\t\t", finalTally[7])
    println("Escape Boundary\t\t", finalTally[8])
    println("Particles Resolved\t", sum(finalTally[3:8]))
end
