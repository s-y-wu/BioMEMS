"""
    approach_wall!(initxy, dx, dy, stepsize) -> initxy::Array{Float64,1}

Shorten proposed vector into a parylene wall face with no catalase.
"""
function approach_wall!(initxy::Array{Float64,1},
                        dx::Float64, dy::Float64,
                        stepsize::Float64)
    newx = initxy[1] + stepsize*dx
    newy = initxy[2] + stepsize*dy
    # Recursively shorten the proposed vector
    if inwalls(newx, newy)
        return approach_wall!(initxy, dx, dy, stepsize * 0.5)
    else
        initxy[1] = newx
        initxy[2] = newy
        return initxy
    end
end
