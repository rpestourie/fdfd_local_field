function rescaling(x, lb, ub)
    @assert all([x <= 1, x >= 0])
    lb + x * (ub-lb)
end

function create_parameters(number_holes, number_training_data, δ, lb, ub)
    ps_vec = zeros(number_holes)
    for it_training = 1:number_training_data
        cur_ps = rescaling.(rand(number_holes), lb, ub)
        ps_vec = vcat(ps_vec, cur_ps)
        for it_hole = 1:number_holes
            perturb = zeros(number_holes)
            perturb[it_hole]+= δ
            ps_vec = vcat(ps_vec, cur_ps .+ perturb)
        end
    end
    return transpose(reshape(ps_vec[number_holes+1:end], (number_holes, number_training_data*6)))
end
