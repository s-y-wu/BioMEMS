# Author: Sean Wu
# Last Updated: November 11, 2020

"Resolves collisions into parylene wall face with no catalase. Recursively shortens the proposed vector"
function approach_wall!(initxy::Array{Float64,1},
                        dx::Float64, dy::Float64,
                        stepSize::Float64)::Array{Float64,1}
    newx = initxy[1] + stepSize*dx
    newy = initxy[2] + stepSize*dy

    if inwalls(newx, newy)
        return approach_wall!(initxy, dx, dy, stepSize * 0.5)
    else
        initxy[1] = newx
        initxy[2] = newy
        return initxy
    end
end
