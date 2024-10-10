function nan_table = computeNaNPercentages(data)
    % COMPUTENANPERCENTAGES calculates the percentage of NaN values in 
    % the `rov_trace` field for each subject across multiple maps.
    %
    % INPUT:
    %   data - A struct containing fields MAP_A, MAP_B, MAP_C, each of which 
    %          contains 12 subfields (e.g., MAP_A1, MAP_A2, ..., MAP_A12).
    %          Each subfield contains several fields, including `rov_trace`, 
    %          which is a table containing signal data.
    %
    % OUTPUT:
    %   nan_table - A table where each row corresponds to a map (MAP_A, MAP_B, MAP_C),
    %               and each column corresponds to a subject (Subject_1, Subject_2, ..., Subject_12).
    %               The entries in the table represent the percentage of NaN values in 
    %               the `rov_trace` for each subject.

    % Define the maps and the number of subjects per map
    maps = {'MAP_A', 'MAP_B', 'MAP_C'};
    num_subjects = 12;
    
    % Initialize a matrix to hold the NaN percentages
    nan_percentages = zeros(length(maps), num_subjects);
    
    % Loop through each map
    for i = 1:length(maps)
        map_name = maps{i};
        
        % Loop through each subject within the current map
        for j = 1:num_subjects
            % Construct the subject name (e.g., MAP_A1, MAP_B2, etc.)
            subject_name = sprintf('%s%d', map_name, j);
            
            % Extract the `rov_trace` field for the current subject
            rov_trace = data.(map_name).(subject_name).rov_trace;
            [M_rows,N_cols]=size(rov_trace);
            % Calculate the percentage of NaN values in the `rov_trace`
            nan_percent = sum((sum(isnan( table2array(rov_trace))) / M_rows) * 100)/N_cols;
            
            % Store the calculated percentage in the matrix
            nan_percentages(i, j) = nan_percent;
        end
    end
    
    % Convert the matrix to a table with appropriate row and column names
    nan_table = array2table(nan_percentages, 'VariableNames', ...
        arrayfun(@(x) sprintf('Subject_%d', x), 1:num_subjects, 'UniformOutput', false), ...
        'RowNames', maps);
end
