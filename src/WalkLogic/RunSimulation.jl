using Random

function randseed()::Int
    maxdigits = 4
    return trunc(Int, 10^maxdigits*rand())
end

function runsimulation!(data::Dict{String,Integer}, seed::Int=randseed())::Dict{String,Integer}
    println("Seed:\t$seed")
    Random.seed!(seed)
    float_arr_one = rand(NUMBER_OF_WALKS)
    float_arr_two = rand(NUMBER_OF_WALKS)
    avgStepsTaken = 0

    for i in 1:NUMBER_OF_WALKS
        peroxidexy = spawnrandompoint(float_arr_one[i], float_arr_two[i])
        steps_sofar = 0
        while peroxidexy != undef && steps_sofar < MAX_STEPS_PER_WALK
            peroxidexy, collision = onestep!(peroxidexy)
            if collision != "no collision"
                data[collision] += 1
            end
            steps_sofar += 1
        end
        avgStepsTaken += index
        if index >= MAX_STEPS_PER_WALK
            data["particles unresolved"] += 1
        end
    end

    avgStepsTaken = avgStepsTaken ÷ NUMBER_OF_WALKS
    data["avg steps taken"] = avgStepsTaken
    return data
end
