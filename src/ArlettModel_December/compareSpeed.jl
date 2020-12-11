global x = rand(1000)

function ret_arr()
    s = [0.0, 0.0]
    for i in x
        s = [s[1] + i, s[2] - i]
    end
end

function mute_arr()
    s = [0.0, 0.0]
    for i in x
        s[1] += i
        s[2] -= i
    end
end

function rand_arr()
    r = rand(1000)
    s = 0.0
    for i in r
        s += i
    end
    return s
end

function rand_one()
    s = 0.0
    for i in 1:1000
        s += rand(Float64)
    end
    return s
end

function rand_seeding()
    Random.seed!(1234)
    return rand(1)
end

function rand_seeding2()
    Random.seed!(1234)
    return help_rand()
end

function help_rand()
    return rand(1)
end

# function hello()
#     return "hello"
# end

function hello(extra)
    return 3 * extra
end
