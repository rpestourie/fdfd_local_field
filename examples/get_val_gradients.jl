include("../src/fdfd_local_field.jl")

using DelimitedFiles

fname="examples/data/test_data__0.01.csv"
data_array = readdlm(fname, ',')
start_index = findnext('.', fname, 1) - 1
end_index = findnext('.', fname, start_index+2) - 1
δ = parse(Float64, fname[start_index:end_index])

real_gd, imag_gd = get_val_gradient_from_data(data_array, δ=δ)
writedlm(fname[1:end-4]*"_real_gd.csv", real_gd, ',')
writedlm(fname[1:end-4]*"_imag_gd.csv", imag_gd, ',')
