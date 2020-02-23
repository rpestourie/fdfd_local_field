include("../src/fdfd_local_field.jl")
cd("examples/")

using BenchmarkTools
using DelimitedFiles

println("$(Threads.nthreads()) threads!")
number_training_data = 100000 # ideally 1e5 here

r = rand()
δ = 1e-2
fname = "test_data_$(round(Int, r*1e5))_$δ.csv"
number_holes = 5
lb = 0.1 # for a blue wavelength this corresponds to a minimum feature of ≈40 nm
ub = 0.95 - lb # this assumes a period of 0.95 λ

# create parameters
ps_array = create_parameters(number_holes, number_training_data, δ, lb, ub)

# reference simulation
refractive_indexes_ref = ones(3) * 1.45
ref_local_field = get_local_field(Float64[0.5], refractive_indexes=refractive_indexes_ref)[3]

# simulations
refractive_indexes_sim = Float64[1.0, 1.0, 1.45]
# TODO: embarassingly parallel code to parallelize
# @btime sim_local_fields = ComplexF32[get_local_field(ps_array[it_ps, :], refractive_indexes=refractive_indexes_sim)[3] for it_ps=1:size(ps_array)[1]]
#
# TODO: create a test with this assertion
# sim_local_fields2 = zeros(ComplexF64, (number_holes+1)*number_training_data)
# @btime @inbounds Base.Threads.@threads for it_ps=1:size(ps_array)[1]
#     sim_local_fields2[it_ps] = get_local_field(ps_array[it_ps, :], refractive_indexes=refractive_indexes_sim)[3]
# end
# @assert all(sim_local_fields .≈ sim_local_fields2)

sim_local_fields = zeros(ComplexF64, (number_holes+1)*number_training_data)
@time @inbounds Base.Threads.@threads for it_ps=1:size(ps_array)[1]
    sim_local_fields[it_ps] = get_local_field(ps_array[it_ps, :], refractive_indexes=refractive_indexes_sim)[3]
end
local_field_data = sim_local_fields./ref_local_field
writedlm("./data/"*fname,hcat(ps_array, real.(local_field_data), imag.(local_field_data)), ',')
