using DelimitedFiles

function consolidate_dataset(substring, dir_name)
    """
    this function goes through all the files in dir_names and consolidates the dataset for the files containing substring
    """
    datafull = []
    for file in cd(readdir, dir_name)
        if occursin(substring, file)
            if datafull == []
                datafull = copy(readdlm(dir_name*"/"*file, ','))
            else
                cur_data = readdlm(dir_name*"/"*file, ',')
                datafull = vcat(datafull, cur_data)
            end
        end
    end
    return datafull
end


dir_name = "./examples/data"
substring = "imag_gd"
datafull = consolidate_dataset(substring, dir_name)

writedlm(dir_name*"/consolidated_data_$(substring[1:4]).csv", datafull, ',')
