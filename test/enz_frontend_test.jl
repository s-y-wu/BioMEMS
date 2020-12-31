using Test, DataFrames, Suppressor, HMCResearchRandomWalks.Enz

@testset "Setter for simulation control" begin
    set_THICK_ENZ()
    @test Enz.THICK_ENZ == true
    set_THICK_ENZ(false)
    @test Enz.THICK_ENZ == false
    set_THICK_ENZ(true)
    @test Enz.THICK_ENZ == true
end

@testset "fast custom enz_sim" begin
    set_THICK_ENZ(false)
    set_NUMBER_OF_WALKS(10)
    set_MAX_STEPS_PER_WALK(1000000)
    set_ENZ_STEP_SIZE(0.07)
    output = @capture_out begin enz_sim(5534) end
    correct_output = string(
    "############################\n",
    "       Enz Experiment       \n",
    "############################\n",
    "_________Parameters_________\n",
    "Enzyme Thickness:\t0.2\n",
    "# of trials:\t\t10\n",
    "# of steps (max):\t1000000\n",
    "Step size, water:\t0.1\n",
    "Step size, enz:\t\t0.07\n",
    "Random seed:\t\t5534\n",
    "_________Results____________\n",
    "# in sensor:\t\t10\n",
    "# of escaped:\t\t0\n",
    "# unresolved:\t\t0\n"
    )
    @test output === correct_output
end

@testset "find_enz_print" begin
    n = 12312020
    m = 1225
    set_NUMBER_OF_WALKS(n)
    set_MAX_STEPS_PER_WALK(m)
    output = @capture_out begin Enz.find_enz_print() end
    correct_output = string(
    "############################\n",
    "   Compare Enz Step Sizes   \n",
    "############################\n",
    "_________Parameters_________\n",
    "# of trials:\t\t$n\n",
    "# of steps (max):\t$m\n",
    "Step size, water:\t0.1\n",
    )
    @test output === correct_output
end

@testset "find_enz" begin
    set_NUMBER_OF_WALKS(5)
    set_MAX_STEPS_PER_WALK()
    @suppress begin
        global find_enz_test_df = find_enzstepsize(
            [0.003, 0.005, 0.007],
            1234
        )
    end
    thk = "thick, 2 um"
    thn = "thin, 0.2 um"
    correct_df = DataFrame(
        thick_or_thin = [thk, thn, thk, thn, thk, thn],
        enz_step_size = [0.003, 0.003, 0.005, 0.005, 0.007, 0.007],
        sensor_yield = [1,5,3,5,2,5],
        escaped = [4,0,2,0,3,0],
        unresolved = [0,0,0,0,0,0]
    )
    @test find_enz_test_df == correct_df
end
