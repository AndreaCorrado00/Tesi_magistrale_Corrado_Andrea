function db_table = build_table_dataset_with_subs(data)
    % Names of the maps
    map_names = ["MAP_A", "MAP_B", "MAP_C"];
    
    % Initialize the output table
    db_table = table();
    
    % Loop through each map (MAP_A, MAP_B, MAP_C)
    for i = 1:length(map_names)
        map = map_names(i);
        
        % Retrieve the fields for the specific map (e.g., MAP_A1, MAP_A2, ...)
        map_fields = fieldnames(data.(map));
        
        for j = 1:length(map_fields)
            % Get the field name (e.g., MAP_A1)
            field_name = map_fields{j};
            
            % Extract the subject ID from the field name
            subject_id = str2double(regexprep(field_name, '\D', ''));  % Extract numeric part from the string
            
            % Retrieve the signals from the specified field's table
            map_signals = table2array(data.(map).(field_name).rov_trace)';
            
            % Add the subject ID and class columns
            % Creating a new table that includes the subject ID and map class
            subject_signals = [repmat(subject_id, height(map_signals), 1), ...
                               map_signals, ...
                               repmat(string(map), height(map_signals), 1)];
            
            % Convert the array to a table and concatenate with the output table
            db_table = [db_table; array2table(subject_signals)];
        end
    end

    % Define the variable names for the table
    variableNames = cell(1, width(subject_signals));  % Create an array to hold column names
    variableNames{1} = 'id';  % The first column is for subject ID
    for k = 2:width(subject_signals)-1
        variableNames{k} = num2str(k-1);  % Point number for each signal (e.g., 1, 2, 3, ...)
    end
    variableNames{end} = 'class';  % The last column is for the class name (map name)
    
    % Set the variable names for the output table
    db_table.Properties.VariableNames = variableNames;
end
