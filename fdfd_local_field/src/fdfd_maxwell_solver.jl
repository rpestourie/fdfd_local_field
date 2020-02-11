"""
```Maxwell_2d(Lx, Ly, ϵ, ω, dpml, resolution; Rpml=1e-20, show_geometry=false)```

This function compute the finite difference operator for a Maxwell Finite Difference Frequency Domain solver.
The solver is in 2D and handles the out-of-plane polarization.

Boundary conditions:

- periodic in x
- pml at y = Ly and y = 0

Argument:

- Lx : length in x direction
- Ly : length in y direction
- ϵ : function that gives the permittivity in function of a spatial point
- ω : frequency
- dpml : width of the pml
- resolution : number of points per unit
- Rpml : pml extinction parameter
- show_geometry : flag to plot the geometry

Returns:

- the operator matrix
- the number of points in x direction
- the number of points in y direction
- x grid points
- y grid points

"""
function Maxwell_2d(Lx, Ly, ϵ, ω, dpml, resolution;
    Rpml=1e-20)

    nx = round(Int, Lx * resolution) #nb point in x
    ny = round(Int, (Ly + 2*dpml) * resolution) #nb points in y
    npml = round(Int, dpml*resolution)
    δ = 1/resolution

    # coordinates centered in (0,0)
    x = (1:nx) * δ
    y = (1-npml:ny-npml) * δ

    #define the laplacian operator in x direction
    o = ones(nx)/δ
    # D = spdiagm((-o,o), (-1,0), nx+1, nx)   # v0.6
    Imat, J, V = SparseArrays.spdiagm_internal(-1 => -o, 0 => o);
    D = sparse(Imat, J, V, nx+1, nx)
    ∇2x = transpose(D) * D
    #periodic boundary condition in x direction
    ∇2x[end,1]=-1/δ^2
    ∇2x[1,end]=-1/δ^2

    #define the laplacian operator in y direction
    o = ones(ny) / δ
    σ0 = -log(Rpml) / (4dpml^3/3)
    y′=((-npml:ny-npml) .+ 0.5) * δ

    σ = Float64[ξ>Ly ? σ0 * (ξ-Ly)^2 : ξ<0 ? σ0 * ξ^2 : 0.0 for ξ in y]
    Σ = spdiagm(0 => 1.0 ./(1 .+ (im/ω)*σ))
    σ′ = Float64[ξ>Ly ? σ0 * (ξ-Ly)^2 : ξ<0 ? σ0 * ξ^2 : 0.0 for ξ in y′]
    Σ′ = spdiagm(0 => 1.0 ./(1 .+ (im/ω)*σ′))
    # D = spdiagm((-o, o), (-1, 0), ny+1, ny)   # v0.6
    Imat, J, V = SparseArrays.spdiagm_internal(-1 => -o, 0 => o);
    D = sparse(Imat, J, V, ny+1, ny)
    ∇2y = Σ * transpose(D) * Σ′ * D

    #get 2d laplacian using kronecker product
    Ix = sparse(1.0I, nx, nx)
#     Ix = speye(nx)   # v0.6
    Iy = sparse(1.0I, ny, ny)
#     Iy = speye(ny)   # v0.6
    ∇2d = (kron(Ix, ∇2y) + kron(∇2x, Iy))

    # geometry = ComplexF64[ϵ(ξ, ζ) for ζ in y, ξ in x]
    geometry = ϵ(x, y)

    return (∇2d - spdiagm(0 => reshape(ω^2 * geometry, length(x)*length(y))),
    nx, ny, x, y)
end
