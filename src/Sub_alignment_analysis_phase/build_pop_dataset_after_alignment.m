function pop_dataset_aligned = build_pop_dataset_after_alignment(data)
    % Constructs a population dataset after alignment.
    % This function aggregates traces across subjects and maps, 
    % aligning and concatenating them into a single dataset.
    %
    % INPUT:
    %   data - Struct containing traces for different maps and subjects.
    %
    % OUTPUT:
    %   pop_dataset_aligned - Struct containing concatenated and aligned traces for each map.

    map_names = ["MAP_A", "MAP_B", "MAP_C"];
    

    for i = 1:3
        % Initialize arrays to hold concatenated traces
        rov_records = [];
        ref_records = [];
        spare1_records = [];
        spare2_records = [];
        spare3_records = [];
        map = map_names(i);
        sub_names=fieldnames(data.(map));

        for j = 1:length(sub_names)
            sub = string(sub_names(j));
            % Concatenate traces from all subjects for the current map
            rov_records = [rov_records, table2array(data.(map).(sub).rov_trace)];
            ref_records = [ref_records, table2array(data.(map).(sub).ref_trace)];
            spare1_records = [spare1_records, table2array(data.(map).(sub).spare1_trace)];
            spare2_records = [spare2_records, table2array(data.(map).(sub).spare2_trace)];
            spare3_records = [spare3_records, table2array(data.(map).(sub).spare3_trace)];
        end
        % Store the concatenated traces in the output struct
        pop_dataset_aligned.(map).rov_trace = array2table(rov_records);
        pop_dataset_aligned.(map).ref_trace = array2table(ref_records);
        pop_dataset_aligned.(map).spare1_trace = array2table(spare1_records);
        pop_dataset_aligned.(map).spare2_trace = array2table(spare2_records);
        pop_dataset_aligned.(map).spare3_trace = array2table(spare3_records);
    end
end



