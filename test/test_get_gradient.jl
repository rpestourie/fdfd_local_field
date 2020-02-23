data_array = [0.405503  0.707334  0.211959  0.2539  0.479168  0.161135  -0.0888367
0.415503  0.707334  0.211959  0.2539  0.479168  0.153381  -0.102154
0.405503  0.717334  0.211959  0.2539  0.479168  0.14144   -0.106894
0.405503  0.707334  0.221959  0.2539  0.479168  0.150405  -0.0882103
0.405503  0.707334  0.211959  0.2639  0.479168  0.135277  -0.108619
0.405503  0.707334  0.211959  0.2539  0.489168  0.162739  -0.0966177]

real_gd, imag_gd = get_val_gradient_from_data(data_array, δ=1e-2)

@test imag_gd[1, end-4] == (data_array[2, end] - data_array[1, end])*1e2
@test imag_gd[1, end-2] == (data_array[4, end] - data_array[1, end])*1e2
@test imag_gd[1, end] == (data_array[6, end] - data_array[1, end])*1e2
@test real_gd[1, end-4] == (data_array[2, end-1] - data_array[1, end-1])*1e2


# note that this value is wrong because the data was simulated with a δ=1e-2 pertubation
real_gd, imag_gd = get_val_gradient_from_data(data_array, δ=1e-4)

@test imag_gd[1, end-4] ≈ (data_array[2, end] - data_array[1, end])*1e4
