"   flow

Analyze hydrogen peroxide position to compute the magnitude of flow

By laminar flow, all nonzero flow biases the particle downstream
in the positive x direction.
"
function flow_arlett(xy::Array{Float64,1})
    y = xy[2]
    if !FLOW_BIAS || y <= WALL_Y || inenz(xy)
        return 0
    else
        xdisplacementbias = getspeed(y) * SECONDS_PER_STEP
        return xdisplacementbias
    end
end

# lengths are in microns
const V_MAX = 6326
const R = 1270

"   getspeed

Compute the approximate laminar flow bias on the particle; magnitude of flow increases with the y-coordinate

Excerpt from \"Simulating Chemical Cross-Talk in High Density Enzymatic Biosensors\" by Sonali Madisetti:
\" In the experimental conditions, the probe had a constant flow of water, in which water entered the
system at 40 mL/s for 700 seconds through a 0.21 in x 0.1 in pipe and exited at a similar rate. The radius
of the rectangular probe apparatus was around 1270 microns. From Q = v_eff * A, where Q represented the
flow-rate, v_eff was approximately 4217 um/s. For a square pipe, it can be derived that v_eff = (2/3)v_max,
and thus that v_max = 6326 um/s. From there, using the velocity equation
                                    v(r) = v_max * (1 - r^2 / R^2)
where r is the y-distance from the center and R is the radius of the pipe. \"
"
function getspeed(y::Float64)::Float64
    r = R - y
    return V_MAX * (1 - (r^2) / (R^2))
end
