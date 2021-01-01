using Test, Suppressor, DataFrames
using HMCResearchRandomWalks.ViewOut

const test_df = DataFrame(test_title1 = [1,2,3,4],
                        test_title2 = ["ab", "cd", "ef", "gh"])

@testset "savedata" begin
    current_df(test_df)
    current_seed(8765)
    @suppress_out begin
        global path1 = savedata()
    end
    _, ext = splitext(path1)
    @test isfile(path1)
    @test occursin("8765", path1)
    @test ext === ".csv"

    @suppress_out begin
        global path2 = savedata("test_input_name.csv")
    end
    @test isfile(path2)
    @test occursin("test_input_name.csv", path2)

    output = @capture_out begin
        global path3 = savedata("test_safe_name.csv", test_df)
    end
    correct_output = string("CSV File saved at the given path:\n", path3,"\n")
    @test isfile(path3)
    @test occursin("test_safe_name.csv", path3)
    @test output === correct_output

    correct_warning = "File name must end with the .csv extension"
    error = @capture_err begin
        savedata("test_bad_name", test_df)
    end
    @test occursin(correct_warning, error)
end

@testset "savetofolder" begin
    current_df(test_df)
    current_seed(4321)
    current_path("out/noflowdata/")
    output = @capture_out begin
        global path4 = savetofolder()
    end
    correct_output = string("CSV File saved at the given path:\n", path4,"\n")
    @test output === correct_output
    @test isfile(path4)
    @test occursin("seed_4321", path4)
end

@testset "loaddata" begin
    for p in [path1, path2, path3, path4]
        loaded_test_df = loaddata(p)
        @test loaded_test_df == test_df
    end

    easy_path = "/out/test_input_name.csv"
    easy_df = loaddata(easy_path, true)
    @test easy_df == test_df
end

@testset "clean up saved test files" begin
    for p in [path1, path2, path3, path4]
        rm(p)
        @test !isfile(p)
    end
end
