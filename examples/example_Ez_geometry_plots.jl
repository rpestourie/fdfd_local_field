include("../src/fdfd_local_field.jl")
using Plots
pyplot()

### reference simulation
refractive_indexes = ones(3) * 1.45
ps = [0.75, 0.5, 0.66, 0.33, 0.66, 0.5, 0.75, 0.5, 0.66, 0.33]
x, y, Ez, dpml, dsource, resolution = simulation_hole_layers_unit_cell(ps, refractive_indexes=refractive_indexes, frequency=0.25)

heatmap(real.(ϵ_hole_layers(x, y, ps, refractive_indexes=refractive_indexes)))
gui()

heatmap(real.(Ez), c=ColorGradient([:red, :white, :blue]))
gui()

### structure simulation
refractive_indexes = Float64[1.0, 1.0, 1.45]
x, y, Ez, dpml, dsource, resolution = simulation_hole_layers_unit_cell(ps, refractive_indexes=refractive_indexes)

heatmap(real.(ϵ_hole_layers(x, y, ps, refractive_indexes=refractive_indexes)))
gui()

heatmap(real.(Ez), c=ColorGradient([:red, :white, :blue]))
gui()
