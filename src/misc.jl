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


function finite_difference_deriv(curv, vperturb, δ)
    return (vperturb-curv)/δ
end

function get_val_gradient_from_data(data_array; δ=1e-2)
    n_variable = size(data_array)[2]-2
    n_data_val_gradient = size(data_array)[1]÷(1+n_variable)

    real_val_gradient = zeros(Float64, (n_data_val_gradient, 2*n_variable+1))
    imag_val_gradient = zeros(Float64, (n_data_val_gradient, 2*n_variable+1))

    for i=1:n_data_val_gradient
        real_vector_data = data_array[(i-1)*(1+n_variable)+1, 1:n_variable] #push the data input
        real_curval = data_array[(i-1)*(1+n_variable)+1, n_variable+1]
        push!(real_vector_data, real_curval)

        imag_vector_data = data_array[(i-1)*(1+n_variable)+1, 1:n_variable]
        imag_curval = data_array[(i-1)*(1+n_variable)+1, n_variable+2]
        push!(imag_vector_data, imag_curval)

        for j=1:n_variable
            push!(real_vector_data, finite_difference_deriv(real_curval, data_array[(i-1)*(1+n_variable)+1+j, n_variable+1], δ))
            push!(imag_vector_data, finite_difference_deriv(imag_curval, data_array[(i-1)*(1+n_variable)+1+j, n_variable+2], δ))
        end
        real_val_gradient[i,:] = real_vector_data
        imag_val_gradient[i,:] = imag_vector_data
    end
    return real_val_gradient, imag_val_gradient
end
