function newData = align_and_filter_dataset(original_data, sub_align_data, filter, RP, Fc)
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
                if filter
                    % Apply wavelet denoising if specified
                    rov = denoise_ecg_wavelet(rov - mean(rov), Fc, 'sym4', 9);
                end

                ref = original_data.(map).(sub).ref_trace{:, k};
                spare1 = original_data.(map).(sub).spare1_trace{:, k};
                spare2 = original_data.(map).(sub).spare2_trace{:, k};
                spare3 = original_data.(map).(sub).spare3_trace{:, k};

                if filter
                    % Apply wavelet denoising to other traces if specified
                    newData.(map).(sub).ref_trace{:, k} = denoise_ecg_wavelet(ref - mean(ref), Fc, 'sym4', 9);
                    newData.(map).(sub).spare1_trace{:, k} = denoise_ecg_wavelet(spare1 - mean(spare1), Fc, 'sym4', 9);
                    newData.(map).(sub).spare2_trace{:, k} = denoise_ecg_wavelet(spare2 - mean(spare2), Fc, 'sym4', 9);
                    newData.(map).(sub).spare3_trace{:, k} = denoise_ecg_wavelet(spare3 - mean(spare3), Fc, 'sym4', 9);
                end

                % Align the rov trace based on fiducial points and reference point
                FP = sub_align_data.(map).(sub).FP_position_rov{:, k};
                RP_pos = round(RP * Fc); % Convert reference point from seconds to indices
                newData.(map).(sub).rov_trace{:, k} = align_rov_traces(FP, RP_pos, rov);
            end
        end
    end
end
