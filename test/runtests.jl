using Test
include("../src/fdfd_local_field.jl")

@testset "fdfd_local_field" begin
    @testset "maxwell_fdfd_solver" begin include("test_fdfd_maxwell_solver.jl") end
    @testset "pixel averaging" begin include("test_geometry_code.jl") end
    @testset "finite difference gradient" begin include("test_get_gradient.jl") end
    @testset "parallelization" begin include("test_parallel_vs_serial.jl") end
end
