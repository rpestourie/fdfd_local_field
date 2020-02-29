using DelimitedFiles

function generate_datasets(namedir, application_name, nbpoints)
    """
    This function takes the full dataset and sets the first nbpoints points in a test set,
        then creates an ever growing train dataset by increments of nboints"""

    fulldataset = readdlm("examples/data/consolidated_data_$application_name.csv", ',')
    nb_train = size(fulldataset)[1]

    testdataset = fulldataset[1:nbpoints,:]
    writedlm(namedir*"test_dataset_$application_name.csv", testdataset, ',')

    i = 2
    while nbpoints * i <= nb_train
        writedlm(namedir*"train_dataset_$(application_name)_$(i-1).csv", fulldataset[nbpoints+1:i*nbpoints,:], ',')
        i+=1
    end
end


application_name = "real"
namedir = "examples/data/"
nbpoints = 10000
generate_datasets(namedir, application_name, nbpoints)
