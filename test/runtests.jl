using HMCResearchRandomWalks
using Test

spawnrandompoint()

# @testset "HMCResearchRandomWalks.jl" begin
#     # Write your tests here.
#     spawnrandompoint()
# end

using PkgTemplates

t = Template(;user="s-y-wu",license="MIT",authors=["Sean Wu"],plugins=[TravisCI(),Coveralls(),AppVeyor(),Documenter{TravisCI}(),],)

generate("MyRandomWalks", t)
