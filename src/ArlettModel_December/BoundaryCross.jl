# Author: Sean Wu
# Last Updated: November 11, 2020

include("arlettParameters.jl")

"Corrects displacement vectors with head and tail at two different layers"

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
