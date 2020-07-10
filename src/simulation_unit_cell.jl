# TODO: modularize code, write simulate_unit_cell independent of the geometry, all geometry related code should be in geometry_code

"""
```x, y, Ez, dpml, dsource, resolution = simulate_unit_cell(ps; refractive_indexes=zeros(3), frequency=1, interstice = 0.5, hole = 0.75, Ly = 17)```
This function simulates Helmholtz equation for a unit-cell consisting of holes in a substrate."""
function simulation_hole_layers_unit_cell(ps; refractive_indexes=zeros(3), frequency=1, interstice = 0.5, hole = 0.75, Ly = 17)
    #parameters for Maxwell solver
    # specific to the unit-cell
    Lx = 0.95
    # Ly = 17
    ω = 2pi*frequency
    dpml = 2
    resolution = 40
    dsource = 1

    # specific to the unit-cell
    if refractive_indexes == zeros(3)
        refractive_indexes = Float64[1.0, 1.0, 1.45]
    end

    # ϵ_hole_layers is specific to the unit cell, all the rest is not
    A, nx, ny, x, y = Maxwell_2d(Lx, Ly,
    (x,y)-> ϵ_hole_layers(x, y, ps, refractive_indexes=refractive_indexes, interstice = interstice, hole = hole),
    ω, dpml, resolution)

    J = zeros(ComplexF64, (ny, nx))
    J[end-(dpml + dsource) * resolution, :]  = 1im  * ω * ones(nx)*resolution
    Ez = reshape(A \ J[:], (ny, nx))

    return x, y, Ez, dpml, dsource, resolution
end

"""
```function simulation_pillar_unit_cell(p; kwargs=Dict())```
This function simulated Helmholtz equation for a unit-cell consisting of a pillar on top of a substrate.

@ parameters:

- p: width of the pillar in adimensional units
- kwargs: dictionary with parameters of the unit cell we would want to change

@return (everything needed to compute the local field)

- x, y: coordinates
- Ez: values of the electric field out of plane
- dpml
- dsource is the distance of the source from the pml (in adimensional unit), also use for the distance between the monitor and the pml
- resolution
"""
function simulation_pillar_unit_cell(p; kwargs=Dict())
    @assert length(p) == 1
    
    # parameter unit cell
    height= get(kwargs, "height", 600/443)
    
    #parameters for Maxwell solver
    refractive_indexes= get(kwargs, "refractive_indexes", [1., 2., 1.4])
    frequency= get(kwargs, "frequency", 1.)
    Ly = get(kwargs, "Ly", 7)
    resolution = get(kwargs, "resolution", 40)
    dpml = get(kwargs, "dpml", 2)
    Lx = get(kwargs, "Lx", 1)
    dsource = get(kwargs, "dsource", 1)
    
    ω = 2pi*frequency

    # specific to the unit-cell
    A, nx, ny, x, y = Maxwell_2d(Lx, Ly,
    (x,y)-> ϵ_pillar_function(x, y, [p, height], refractive_indexes=refractive_indexes),
    ω, dpml, resolution)

    J = zeros(ComplexF64, (ny, nx))
    J[end-(dpml + dsource) * resolution, :]  = 1im  * ω * ones(nx)*resolution
    Ez = reshape(A \ J[:], (ny, nx))

    return x, y, Ez, dpml, dsource, resolution
end



"""
```x, y, zeroth_order = get_local_field(ps; refractive_indexes=zeros(3), frequency=1, interstice = 0.5, hole = 0.75, Ly = 17)```
    this function simulates the structure with holes using Maxwell's equations,
    and computes the zeroth-order Fourier coefficient.

input arguments:

- ps: array with parametrization of the unit-cell corresponding the widths of holes in the substrate
- refractive_indexes: optional argument with refractive indexes of background, hole and substrate. For reference simulation: set refractive indexes to ones(3)*eps_substrate
- frequency (optional): frequency of simulation
- interstice (optional): number of wavelength between holes
- hole (optional): number of wavelength inside holes
- Ly (optional): length of the computational domain

returns:

- return the complex zeroth order Fourier coefficient of the transmitted field
"""
function get_local_field(ps; simulate_unit_cell=simulation_hole_layers_unit_cell, refractive_indexes=zeros(3), frequency=1, interstice = 0.5, hole = 0.75, Ly = 17)
    x, y, Ez, dpml, dsource, resolution = simulate_unit_cell(ps,
    refractive_indexes=refractive_indexes, frequency=frequency,
    interstice = interstice, hole = hole, Ly = Ly)
    return x, y, mean(Ez[(dpml + dsource) * resolution, :])
end

function get_local_field(ps, simulate_unit_cell; kwargs=Dict())
    x, y, Ez, dpml, dsource, resolution = simulate_unit_cell(ps, kwargs=kwargs)
    return x, y, mean(Ez[(dpml + dsource) * resolution, :])
end
