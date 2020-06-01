"""
```ϵ_hole_layers(x, y, ps, interstice = 0.5, hole = 0.75)```
return the permittivity of a unit-cell which consists of air holes in silica

Arguments:

- ps : widths of the air holes (need to be unit-less)
- refractive_indexes : optional argument with refractive indexes of background, hole and substrate. For reference simulation: set refractive indexes to ones(3)*eps_substrate
- interstice (optional): number of wavelength in between holes
- hole (optional): number of wavelength in the holes

Returns:

- geometry : a complex array with the epsilon data of the unit-cell
"""
function ϵ_hole_layers(x, y, ps; refractive_indexes=zeros(3), interstice = 0.5, hole = 0.75)
    @assert length(x)> 2 # makes sure δ is defined

    nx, ny = length(x), length(y)
    δ = x[2] - x[1]
    Ly_pml = y[end] - y[1] + δ
    Lx = x[end] - x[1] + δ

    @assert all(ps .> δ) # makes sure pixel-averaging handles all cases
    @assert all(ps .<= Lx) # makes sure that the holes are not bigger than the period

    # material properties of the unit-cell
    if refractive_indexes == zeros(3)
        refractive_index_background = 1.0
        refractive_index_hole = 1.0
        refractive_index_substrate = 1.45
    else
        refractive_index_background, refractive_index_hole,
        refractive_index_substrate = refractive_indexes
    end

    eps_background, eps_hole, eps_substrate =
    refractive_index_background^2, refractive_index_hole^2,
    refractive_index_substrate^2

    geometry = ones(ComplexF64, ny, nx) * eps_background

    index_top_substrate = floor(Int64, Ly_pml * 0.35/ δ) # 80% of the domain is substrate

    # substrate
    geometry[index_top_substrate:end, :] .= eps_substrate

    # handles case for sub-pixel averaging
    if x[nx÷2] == 0
        w_offset=1/2
    else
        w_offset=0
    end

    # holes
    number_holes = length(ps)
    n_inter_hole = floor(Int64, interstice / refractive_index_substrate / δ)
    n_hole_height = floor(Int64, hole / δ)

    @assert index_top_substrate + number_holes * (n_inter_hole + n_hole_height) < ny
    # makes sure that Ly is big enough for the holes (possibly in PML)

    for it_holes = 1:number_holes
        half_width = ps[it_holes]/2δ - w_offset
        n_half_width = floor(Int64, half_width)
        weight_eps_hole = half_width - n_half_width

        # inside holes
        n_start = floor(Int64, (nx - 2*n_half_width)/2 - w_offset)
        geometry[index_top_substrate + it_holes * n_inter_hole + (it_holes-1) *
        n_hole_height + 1:index_top_substrate + it_holes *
        (n_inter_hole + n_hole_height),
        n_start + 1: n_start + floor(Int64, 2*(n_half_width + w_offset)) + 1] .=
        eps_hole

        # pixel averaging
        # left
        geometry[index_top_substrate + it_holes * n_inter_hole + (it_holes-1) *
        n_hole_height + 1:index_top_substrate + it_holes *
        (n_inter_hole + n_hole_height), n_start] .=
        weight_eps_hole * eps_hole + (1 - weight_eps_hole) * eps_substrate
        # right
        geometry[index_top_substrate + it_holes * n_inter_hole + (it_holes-1) *
        n_hole_height + 1:index_top_substrate + it_holes *
        (n_inter_hole + n_hole_height), end-n_start+1] .=
        weight_eps_hole * eps_hole + (1 - weight_eps_hole) * eps_substrate
    end

    return geometry
end
