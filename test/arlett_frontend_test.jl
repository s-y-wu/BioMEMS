using Test, DataFrames, Suppressor, HMCResearchRandomWalks.Arlett

@testset "Setters for simulation controls" begin
    set_NUMBER_OF_WALKS()
    @test Arlett.NUMBER_OF_WALKS == 1000
    set_NUMBER_OF_WALKS(10)
    @test Arlett.NUMBER_OF_WALKS == 10

    set_MAX_STEPS_PER_WALK()
    @test Arlett.MAX_STEPS_PER_WALK == 1485604
    set_MAX_STEPS_PER_WALK(2000000)
    @test Arlett.MAX_STEPS_PER_WALK == 2000000

    set_FLOW_BIAS()
    @test Arlett.FLOW_BIAS
    set_FLOW_BIAS(false)
    @test !Arlett.FLOW_BIAS
    set_FLOW_BIAS(true)
    @test Arlett.FLOW_BIAS

    set_CATALASE_ON_WALLS()
    @test Arlett.CATALASE_ON_WALLS
    set_CATALASE_ON_WALLS(false)
    @test !Arlett.CATALASE_ON_WALLS
    set_CATALASE_ON_WALLS(true)
    @test Arlett.CATALASE_ON_WALLS
end

@testset "fast custom arlett_sim" begin
    set_NUMBER_OF_WALKS(10)
    set_MAX_STEPS_PER_WALK(1000000)
    set_FLOW_BIAS(true)
    set_CATALASE_ON_WALLS(true)
    output = @capture_out begin arlett_sim(1234) end
    correct_output = string(
    "############################\n",
    "      Arlett Simulation     \n",
    "############################\n",
    "_________Parameters_________\n",
    "# of trials:\t\t10\n",
    "# of steps (max):\t1000000\n",
    "Step size, water:\t0.1\n",
    "Step size, enz:\t\t0.005\n",
    "Step size, ppd:\t\t0.001\n",
    "Flow bias on:\t\ttrue\n",
    "Catalase on walls:\ttrue\n",
    "Random seed:\t\t1234\n",
    "_________Results____________\n",
    "Side wall collisions:\t0\n",
    "# caught by catalase:\t4\n",
    "# escaped:\t\t2\n",
    "*Sensors from left to right*\n",
    "# in first:\t\t0\n",
    "# in second:\t\t0\n",
    "# in third (spawn):\t2\n",
    "# in fourth:\t\t1\n",
    "# in fifth:\t\t1\n",
    "# unresolved:\t\t0\n",
    "Average steps taken:\t181302\n"
    )
    @test output === correct_output
end

@testset "getdata_arlett_noflow()" begin
    set_NUMBER_OF_WALKS(10)
    set_MAX_STEPS_PER_WALK(1000000)
    output = @capture_out begin
        global gd_arlett_noflow_test_df = getdata_arlett_noflow(1234)
    end
    correct_output = string(
    "############################\n",
    "      Arlett Simulation     \n",
    "############################\n",
    "_________Parameters_________\n",
    "# of trials:\t\t10\n",
    "# of steps (max):\t1000000\n",
    "Step size, water:\t0.1\n",
    "Step size, enz:\t\t0.005\n",
    "Step size, ppd:\t\t0.001\n",
    "Flow bias on:\t\tfalse\n",
    "Catalase on walls:\tfalse\n",
    "Random seed:\t\t1234\n",
    )
    correct_df = DataFrame(
        nth_trial = [n for n in 1:10],
        inner_crosstalk = [100.0, 100.0, 50.0, 50.0, 50.0,
            25.0, 50.0, 50.0, 50.0, 50.0],
        outer_crosstalk = [0.0 for _ in 1:10]
    )
    @test gd_arlett_noflow_test_df == correct_df
    @test output === correct_output
end

@testset "getdata_arlett_animation" begin
    set_FLOW_BIAS(false)
    set_CATALASE_ON_WALLS(false)
    set_MAX_STEPS_PER_WALK(50)
    output = @capture_out begin
        global gd_arlett_ani_df = getdata_arlett_animation(1234)
    end
    correct_output = string(
    "############################\n",
    "      Arlett Simulation     \n",
    "############################\n",
    "_________Parameters_________\n",
    "# of trials:\t\t1\n",
    "# of steps (max):\t50\n",
    "Step size, water:\t0.1\n",
    "Step size, enz:\t\t0.005\n",
    "Step size, ppd:\t\t0.001\n",
    "Flow bias on:\t\tfalse\n",
    "Catalase on walls:\tfalse\n",
    "Random seed:\t\t1234\n",
    "NOTE: # of steps (max) is ignored\n")
    @test output === correct_output
    @test size(gd_arlett_ani_df) === (17885, 2)
    @test names(gd_arlett_ani_df) == ["x_coordinate",
                                        "y_coordinate"]
end
