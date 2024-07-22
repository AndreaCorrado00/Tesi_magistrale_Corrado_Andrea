function data = refactor_and_save_pop_data(original_data_path,processed_data_path)
    % REFACTOR_AND_SAVE_DATA Refactors map data from multiple files and saves it into a structured dataset.
    %
    %   DATA = REFACTOR_AND_SAVE_DATA(ORIGINAL_DATA_PATH) reads map data from the specified
    %   directory, processes each file, and saves the refactored data into a .mat file.
    %
    %   Inputs:
    %       ORIGINAL_DATA_PATH - String, the path to the directory containing the map data.
    %
    %   Outputs:
    %       DATA - Struct, containing the refactored map data organized by map type and index.

    % Determine the number of elements (files) in the MAP_A directory, excluding '.' and '..'
    n_el = numel(dir(original_data_path + "\MAP_A")) - 2;

    % Loop through each element (file)
    for i = 1:n_el
        % Loop through each map type: A (indifferent), B (effective), C (dangerous)
        for map_name = ["A", "B", "C"]
            % Loading the map data from CSV file
            MAP = readtable(original_data_path + "\MAP_" + map_name + "\MAP_" + map_name + num2str(i) + ".csv");

            % Refactoring the map data (assumed to be performed by the function maps_refactoring)
            MAP = maps_refactoring(MAP);

            % Creating field names for the struct
            main_field = 'MAP_' + map_name;
            sub_field = 'MAP_' + map_name + num2str(1);
            
            if i==1
                data.(main_field).(sub_field)=MAP;
            else
                % Adding the refactored map data to the struct
                data.(main_field).(sub_field).rov_trace = array2table([table2array(data.(main_field).(sub_field).rov_trace),table2array(MAP.rov_trace)]);
                data.(main_field).(sub_field).ref_trace = array2table([table2array(data.(main_field).(sub_field).ref_trace),table2array(MAP.ref_trace)]);
                data.(main_field).(sub_field).spare1_trace = array2table([table2array(data.(main_field).(sub_field).spare1_trace),table2array(MAP.spare1_trace)]);
                data.(main_field).(sub_field).spare2_trace = array2table([table2array(data.(main_field).(sub_field).spare2_trace),table2array(MAP.spare2_trace)]);
                data.(main_field).(sub_field).spare3_trace = array2table([table2array(data.(main_field).(sub_field).spare3_trace),table2array(MAP.spare3_trace)]);
            end
        end
    end

    % Save the structured dataset to a .mat file
    save(processed_data_path+"\dataset_pop.mat", 'data');
end

