function db_table = build_table_dataset(data)
    % BUILD_TABLE_DATASET Constructs a dataset table from the provided signal data
    %
    % This function processes the signals stored in the 'data' structure across
    % three maps (MAP_A, MAP_B, MAP_C) and builds a table where each row corresponds
    % to a signal point. The table contains:
    % - Columns representing the signal points (1, 2, ..., N),
    % - The last column representing the 'class' (map name, i.e., MAP_A, MAP_B, or MAP_C).
    %
    % The input 'data' is expected to be a struct containing the fields MAP_A, MAP_B,
    % and MAP_C, each containing the signal data for various subjects under those maps.
    %
    % Parameters:
    %   data (struct) - The input dataset containing the signal data for each map
    %                   and corresponding subjects. The data structure should include
    %                   fields 'MAP_A', 'MAP_B', and 'MAP_C', each with signal traces
    %                   stored in the field 'rov_trace'.
    %
    % Output:
    %   db_table (table) - A table containing the signals and associated class labels.
    %                       Each row corresponds to a signal point, and the last column
    %                       indicates the map name (class).
    %
    % Example:
    %   db_table = build_table_dataset(data);
    %
    % Written by: [Your Name], [Date]
    
    map_names = ["MAP_A", "MAP_B", "MAP_C"];
    
    db_table = table(); % Initialize an empty table for the dataset
    
    % Iterate through each map
    for i = 1:3
        map = map_names(i);
        
        % Extract the signal data for the current map (assuming it's stored in 'rov_trace')
        map_signals = table2array(data.(map).rov_trace)';
        
        % Append the map name as the 'class' column for all signals in the current map
        map_signals = [map_signals, repmat(string(map), height(map_signals), 1)];
        
        % Concatenate the current map's signals with the existing data
        db_table = vertcat(db_table, array2table(map_signals));
    end
    
    % Define the variable names for the table (signal point numbers and class)
    variableNames = cell(1, width(map_signals)); 
    for i = 1:width(map_signals)-1
        variableNames{i} = num2str(i); % Signal point numbers (column names)
    end
    variableNames{end} = 'class'; % The last column is the map name (class)
    
    % Assign the variable names to the output table
    db_table.Properties.VariableNames = variableNames;
end
