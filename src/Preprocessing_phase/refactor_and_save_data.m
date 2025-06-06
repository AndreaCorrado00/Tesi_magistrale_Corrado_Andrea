function data = refactor_and_save_data(original_data_path,processed_data_path)
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
        % opts = detectImportOptions(original_data_path + "\MAP_" + map_name + "\MAP_" + map_name + num2str(i) + ".csv");
        opts = detectImportOptions(original_data_path + "\MAP_" + map_name + "\MAP_" + map_name + num2str(i) + ".csv");
        opts = setvartype(opts, 'char');  % Leggi tutto come stringhe
        opts.VariableTypes(:) = {'char'};  % Imposta tutte le colonne come stringhe
        % Loading the map data from CSV file
        MAP= readtable(original_data_path + "\MAP_" + map_name + "\MAP_" + map_name + num2str(i) + ".csv",opts);
        names_field=extract_names(MAP);

        % Refactoring the map data (assumed to be performed by the function maps_refactoring)
        MAP= maps_refactoring(MAP, processed_data_path + '\MAP_' + map_name + '\MAP_' + map_name + num2str(i) + '_refactored.csv');

        % Creating field names for the struct
        main_field = 'MAP_' + map_name;
        sub_field = 'MAP_' + map_name + num2str(i);

        % Adding the refactored map data to the struct
        data.(main_field).(sub_field) = MAP;
        data.(main_field).(sub_field).traces_origin=names_field;
    end
end

% Save the structured dataset to a .mat file
save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\dataset.mat", 'data');
end

