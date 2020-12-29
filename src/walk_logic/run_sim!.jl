"""
    set_NUMBER_OF_WALKS(n)

Determine the number of independent trials to run.

Modify the global variable declared in PARAMETERS_.jl
"""
function set_NUMBER_OF_WALKS(n::Int=1000)
    global NUMBER_OF_WALKS = n
    nothing
end

"""
    set_MAX_STEPS_PER_WALK(s)

Determine when to give up on an unresolving random walk

Modify the global variable declared in PARAMETERS_.jl.
"""
function set_MAX_STEPS_PER_WALK(s::Int=1485604)
    global MAX_STEPS_PER_WALK = s
    nothing
end

"Generate a random seed between 1 to 4 digits long for many default arguments"
function randseed()::Int
    maxdigits = 4
    return trunc(Int, 10^maxdigits*rand())
end

"""
    run_sim!(data, seed) -> data::Dict{String,Integer}

Run generic HMCResearchRandomWalk. Include looping overhead and record data.
"""
function run_sim!(data::Dict{String,Integer}, seed::Int=randseed())
    println("Random seed:\t\t$seed")
    Random.seed!(seed)
    float_arr_one = rand(NUMBER_OF_WALKS)
    float_arr_two = rand(NUMBER_OF_WALKS)
    avgStepsTaken = 0

    for i in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr_one[i], float_arr_two[i])
        steps_sofar = 0
        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = one_step!(peroxidexy)
            if collision != "no collision"
                data[collision] += 1
            end
            steps_sofar += 1
        end
        avgStepsTaken += steps_sofar
        if steps_sofar >= MAX_STEPS_PER_WALK
            data["particles unresolved"] += 1
        end
    end

    avgStepsTaken = avgStepsTaken ÷ NUMBER_OF_WALKS
    data["avg steps taken"] = avgStepsTaken
    return data
end
