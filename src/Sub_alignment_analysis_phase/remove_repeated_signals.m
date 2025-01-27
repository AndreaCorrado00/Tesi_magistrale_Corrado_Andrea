function [unique_dataset, final_table] = remove_repeated_signals(data)
% This function removes duplicate signals from a dataset and creates a final 
% table that lists unique signals with their corresponding metadata.
% 
% Parameters:
%   data (struct): The input dataset containing different maps (e.g., MAP_A, MAP_B, MAP_C) 
%                  and each subject's data with various traces.
%
% Returns:
%   unique_dataset (struct): A dataset with duplicates removed for each subject.
%   final_table (table): A table with unique signals and metadata such as 
%                        subject id, signal values, and map classification.

    % Initialize the unique dataset as the original dataset
    unique_dataset = data;
    
    % Initialize an empty array for the final table
    final_table = [];

    % Loop over the three maps (A, B, C)
    for i = ["A", "B", "C"]
        map = "MAP_" + i;
        
        % Get the list of subjects for the current map
        subjects = fieldnames(data.(map));

        % Loop through each subject
        for j = 1:length(subjects)
            sub = subjects{j};
            
            % Extract the subject number (after the underscore in the subject name)
            sub_num = split(sub, '_');
            sub_num = split(sub_num{2}, i);
            sub_num = sub_num{end};
            
            % Check if the subject has a 'rov_trace' field
            if isfield(data.(map).(sub), 'rov_trace')
                % Convert the 'rov_trace' data to a numeric array
                rov_original = table2array(data.(map).(sub).rov_trace);
                
                % Find unique signals and their corresponding indices
                [unique_rov, uniqueIdx, ~] = unique(rov_original', 'rows', 'stable');
                
                % Get the indices of all traces for the subject
                allIndices = 1:size(rov_original, 2);
                
                % Clean up other traces based on the unique indices
                unique_dataset.(map).(sub).rov_trace = array2table(unique_rov');
                unique_dataset.(map).(sub).ref_trace = data.(map).(sub).ref_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare1_trace = data.(map).(sub).spare1_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare2_trace = data.(map).(sub).spare2_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare3_trace = data.(map).(sub).spare3_trace(:, uniqueIdx);
                
                % Store the number of duplicates removed
                unique_dataset.(map).(sub).n_duplicates = length(allIndices) - length(uniqueIdx);
                
                % Add each unique signal to the final table
                unique_rov = unique_rov';
                for k = 1:length(uniqueIdx)
                    % Create a new row for each unique signal
                    signal_row = unique_rov(:, k);
                    signal_row = [str2double(sub_num), signal_row', map];
                    final_table = [final_table; signal_row];
                end
            end
        end
    end

    % Convert the final table to a more readable format
    final_table = array2table(final_table);
    final_table.Properties.VariableNames{1} = 'id';
    final_table.Properties.VariableNames{end} = 'class';
end
