# TODO: modularize code, write simulate_unit_cell independent of the geometry, all geometry related code should be in geometry_code

"""
```x, y, Ez, dpml, dsource, resolution = simulate_unit_cell(ps; refractive_indexes=zeros(3))```
This function simulates Helmholtz equation for a unit-cell consisting of holes in a substrate."""
function simulation_hole_layers_unit_cell(ps; refractive_indexes=zeros(3))
    #parameters for Maxwell solver
    # specific to the unit-cell
    Lx = 0.95
    Ly = 12
    ω = 2pi
    dpml = 2
    resolution = 40
    dsource = 1

    # specific to the unit-cell
    if refractive_indexes == zeros(3)
        refractive_indexes = Float64[1.0, 1.0, 1.45]
    end

    # ϵ_hole_layers is specific to the unit cell, all the rest is not
    A, nx, ny, x, y = Maxwell_2d(Lx, Ly,
    (x,y)-> ϵ_hole_layers(x, y, ps, refractive_indexes=refractive_indexes),
    ω, dpml, resolution)

    J = zeros(ComplexF64, (ny, nx))
    J[end-(dpml + dsource) * resolution, :]  = 1im  * ω * ones(nx)*resolution
    Ez = reshape(A \ J[:], (ny, nx))

    return x, y, Ez, dpml, dsource, resolution
end

"""
```x, y, zeroth_order = get_local_field(ps; refractive_indexes=zeros(3))```
    this function simulates the structure with holes using Maxwell's equations,
    and computes the zeroth-order Fourier coefficient.

input arguments:

- ps: array with parametrization of the unit-cell corresponding the widths of holes in the substrate
- refractive_indexes: optional argument with refractive indexes of background,
hole and substrate. For reference simulation: set refractive indexes to ones(3)*eps_substrate

returns:

- return the complex zeroth order Fourier coefficient of the transmitted field
"""
function get_local_field(ps; simulate_unit_cell=simulation_hole_layers_unit_cell, refractive_indexes=zeros(3))
    x, y, Ez, dpml, dsource, resolution = simulate_unit_cell(ps,
    refractive_indexes=refractive_indexes)
    return x, y, mean(Ez[(dpml + dsource) * resolution, :])
end