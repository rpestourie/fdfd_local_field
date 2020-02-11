using Test
include("../src/fdfd_local_field.jl")

@testset "fdfd_local_field" begin
    @testset "maxwell_fdfd_solver" begin include("test_fdfd_maxwell_solver.jl") end
    @testset "pixel averaging" begin include("test_geometry_code.jl") end
end
