function db_table = build_table_dataset_with_subs(data)

    % Names of the maps
    map_names = ["MAP_A", "MAP_B", "MAP_C"];
    db_table = table();

    % Loop through each map
    for i = 1:3
        map = map_names(i);
        
        % Retrieve the fields for the specific map (e.g., MAP_A1, MAP_A2, ...)
        map_fields = fieldnames(data.(map));
        
        for j = 1:length(map_fields)
            % Get the field name (e.g., MAP_A1)
            field_name = map_fields{j};
            
            % Extract the subject number from the field name
            subject_id = str2double(regexprep(field_name, '\D', ''));
            
            % Retrieve the signals from the specified field's table
            map_signals = table2array(data.(map).(field_name).rov_trace)';
            
            % Add the subject ID and class columns
            map_signals = [repmat(subject_id, height(map_signals), 1), ...
                           map_signals, ...
                           repmat(string(map), height(map_signals), 1)];
            
            % Convert the array to a table and concatenate with the output table
            db_table = vertcat(db_table, array2table(map_signals));
        end
    end

    % Define the variable names for the table
    variableNames = cell(1, width(map_signals));
    variableNames{1} = 'id'; % subject number
    for k = 2:width(map_signals)-1
        variableNames{k} = num2str(k-1); % point number
    end
    variableNames{end} = 'class'; % class name

    % Set the variable names for the output table
    db_table.Properties.VariableNames = variableNames;
end
