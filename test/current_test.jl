using Test, Suppressor, DataFrames
using HMCResearchRandomWalks.ViewOut
using HMCResearchRandomWalks.ViewOut:
    isdfnull, isseednull, ispathnull, isfilenull

@testset "initialized CURRENT" begin
    @test isdfnull()
    @test isseednull()
    @test ispathnull()
    @test isfilenull()
end

@testset "current_df" begin
    path_err = "No DataFrame loaded. Run the getdata_...(...) method first."
    test_err = @capture_err begin
        current_df()
    end
    @test occursin(path_err, test_err)

    test_df = DataFrame(test_title = [1,2,3])
    current_df(test_df)
    @test test_df === current_df()
end

@testset "current_seed" begin
    path_err = "No seed loaded. Run the getdata_...(...[,seed]) method first."
    test_err = @capture_err begin
        current_seed()
    end
    @test occursin(path_err, test_err)

    test_seed = 4321
    current_seed(test_seed)
    @test "4321" === current_seed()
end

@testset "current_path" begin
    path_err = "No path loaded. Run the getdata_...(...) method first"
    test_err = @capture_err begin
        current_path()
    end
    @test occursin(path_err, test_err)

    test_path = "out/noflowdata/"
    current_path(test_path)
    @test test_path === current_path()
end

@testset "current_file" begin
    file_err = "No file loaded. Run savedata() or savetofolder() first."
    test_err = @capture_err begin
        current_file()
    end
    @test occursin(file_err, test_err)

    test_file = "C:/Users/username/.julia/dev/HMCResearchRandomWalks/out/test.csv"
    current_file(test_file)
    @test test_file === current_file()
end
