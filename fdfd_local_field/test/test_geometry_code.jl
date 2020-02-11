
ps = [37/40]
refractive_indexes = Float64[1., 1., sqrt(3)]
x, y, Ez, dpml, dsource, resolution = simulation_hole_layers_unit_cell(ps, refractive_indexes=refractive_indexes)
δ = x[2] - x[1]
Ly_pml = y[end] - y[1] + δ

# test that the unit-cell is correct
@test resolution == 40
@test Ly_pml == 16

# test that some permittivity are 2 which is the desired pixel-averaging
geometry = real.(ϵ_hole_layers(x, y, ps, refractive_indexes=refractive_indexes))
@test any(isapprox.(geometry, 2.))
