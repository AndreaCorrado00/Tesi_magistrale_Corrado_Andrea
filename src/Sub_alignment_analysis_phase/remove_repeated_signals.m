function [unique_dataset, final_table] = remove_repeated_signals(data)
    % Initialize the unique dataset as the original
    unique_dataset = data;
    
    % Initialize an empty array for the final table
    final_table = [];

    for i = ["A", "B", "C"]
        map = "MAP_" + i;
        
        % Get the list of subjects for this map
        subjects = fieldnames(data.(map));

        

        for j = 1:length(subjects)
            sub = subjects{j};
            sub_num=split(sub,'_');
            sub_num=split(sub_num{2},i);
            sub_num=sub_num{end};
            if isfield(data.(map).(sub), 'rov_trace')
                rov_original = table2array(data.(map).(sub).rov_trace);
                
                % Finding unique signals
                [unique_rov, uniqueIdx, ~] = unique(rov_original', 'rows', 'stable');
                
                % Get indices of all traces
                allIndices = 1:size(rov_original, 2);
                
                % Clean other traces based on the unique indices
                unique_dataset.(map).(sub).rov_trace = array2table(unique_rov');
                unique_dataset.(map).(sub).ref_trace = data.(map).(sub).ref_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare1_trace = data.(map).(sub).spare1_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare2_trace = data.(map).(sub).spare2_trace(:, uniqueIdx);
                unique_dataset.(map).(sub).spare3_trace = data.(map).(sub).spare3_trace(:, uniqueIdx);
                
                % Store the number of duplicates removed
                unique_dataset.(map).(sub).n_duplicates = length(allIndices) - length(uniqueIdx);
                
                % Add to the final table
                unique_rov=unique_rov';
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
