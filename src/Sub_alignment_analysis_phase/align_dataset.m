function newData = align_dataset(original_data,RP, Fc)
    % Aligns and filters the dataset based on the fiducial points and reference points.
    % Applies optional denoising to the signals and aligns them using the provided reference points.
    %
    % INPUTS:
    %   original_data - Struct containing the original traces
    %   sub_align_data - Struct containing the fiducial points for alignment
    %   filter - Boolean indicating whether to apply filtering
    %   RP - Reference point in seconds for alignment
    %   Fc - Sampling frequency for filtering
    %
    % OUTPUT:
    %   newData - Struct with aligned and filtered traces

    newData = original_data;
    
    map_names = ["MAP_A", "MAP_B", "MAP_C"];
    n_sub = length(fieldnames(newData.MAP_A));

    for i = 1:3
        map = map_names(i);
        for j = 1:n_sub
            sub = map + num2str(j);
            for k = 1:width(newData.(map).(sub).rov_trace)
                % Extract signals
                rov = original_data.(map).(sub).rov_trace{:, k};
                ref = original_data.(map).(sub).ref_trace{:, k};
                spare1 = original_data.(map).(sub).spare1_trace{:, k};
                spare2 = original_data.(map).(sub).spare2_trace{:, k};
                spare3 = original_data.(map).(sub).spare3_trace{:, k};
               

                % Align the rov trace based on fiducial points and reference point
                R_peak = original_data.(map).(sub).R_peaks{k};
                RP_pos = round(RP * Fc); % Convert reference point from seconds to indices

                newData.(map).(sub).rov_trace{:, k} = align_traces(R_peak,RP_pos , rov);
                newData.(map).(sub).ref_trace{:, k} = align_traces(R_peak,RP_pos , ref);
                newData.(map).(sub).spare1_trace{:, k} = align_traces(R_peak,RP_pos , spare1);
                newData.(map).(sub).spare2_trace{:, k} = align_traces(R_peak,RP_pos , spare2);
                newData.(map).(sub).spare3_trace{:, k} = align_traces(R_peak,RP_pos , spare3);


            end
        end
    end
end
