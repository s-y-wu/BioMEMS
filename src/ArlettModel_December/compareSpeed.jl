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
