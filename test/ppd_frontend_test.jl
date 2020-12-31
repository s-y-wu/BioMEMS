using Test, Suppressor, DataFrames, HMCResearchRandomWalks.PPD

@testset "setters for simulation control" begin
    set_PPD_ON(true)
    @test PPD.PPD_ON
    @test PPD.PPD_STEP_SIZE == 0.001
    @test PPD.STEP_SIZE_DICT["ppd"] == 0.001

    set_PPD_ON(false)
    @test !PPD.PPD_ON
    @test PPD.PPD_STEP_SIZE == 0.1
    @test PPD.STEP_SIZE_DICT["ppd"] == 0.1
end

@testset "default ppd_sim" begin
    set_PPD_ON()
    set_NUMBER_OF_WALKS()
    set_MAX_STEPS_PER_WALK()
    output = @capture_out begin ppd_sim(8925) end
    correct_output = string(
    "############################\n",
    "       PPD Experiment       \n",
    "############################\n",
    "_________Parameters_________\n",
    "PPD on sensor:\t\ttrue\n",
    "# of trials:\t\t1000\n",
    "# of steps (max):\t1485604\n",
    "Step size, water:\t0.1\n",
    "Step size, PPD:\t\t0.001\n",
    "Random seed:\t\t8925\n",
    "_________Results____________\n",
    "# in sensor:\t\t462\n",
    "# of escaped:\t\t538\n",
    "# unresolved:\t\t0\n"
    )
    @test output === correct_output
end

@testset "fast custom ppd_sim" begin
    set_PPD_ON(false)
    set_NUMBER_OF_WALKS(10)
    set_MAX_STEPS_PER_WALK(1000000)
    output = @capture_out begin ppd_sim(5534) end
    correct_output = string(
    "############################\n",
    "       PPD Experiment       \n",
    "############################\n",
    "_________Parameters_________\n",
    "PPD on sensor:\t\tfalse\n",
    "# of trials:\t\t10\n",
    "# of steps (max):\t1000000\n",
    "Step size, water:\t0.1\n",
    "Random seed:\t\t5534\n",
    "_________Results____________\n",
    "# in sensor:\t\t10\n",
    "# of escaped:\t\t0\n",
    "# unresolved:\t\t0\n"
    )
    @test output === correct_output
end

@testset "find_ppd_print" begin
    n = 420
    m = 2000
    set_NUMBER_OF_WALKS(n)
    set_MAX_STEPS_PER_WALK(m)
    output = @capture_out begin PPD.find_ppd_print() end
    correct_output = string(
    "############################\n",
    "   Compare PPD Step Sizes   \n",
    "############################\n",
    "_________Parameters_________\n",
    "# of trials:\t\t$n\n",
    "# of steps (max):\t$m\n",
    "Step size, water:\t0.1\n",
    )
    @test output === correct_output
end

@testset "find_ppd" begin
    set_NUMBER_OF_WALKS(50)
    set_MAX_STEPS_PER_WALK()
    @suppress begin
        global find_ppd_test_df = find_ppdstepsize([0.001, 0.002], 6520)
    end
    correct_df = DataFrame(
        ppd_step_size = [0.001, 0.002],
        sensor_yield = [20, 38],
        escaped = [30, 12],
        unresolved = [0, 0]
    )
    @test find_ppd_test_df == correct_df
end
