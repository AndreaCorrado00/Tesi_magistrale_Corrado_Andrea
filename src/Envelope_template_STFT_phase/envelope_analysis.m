function envelope_features = envelope_analysis(env_dataset, fc)

    envelope_features = [];  % Initialize an empty matrix to store features

    maps = ["MAP_A", "MAP_B", "MAP_C"];

    for i = 1:3
        map = maps(i);
        subs = fieldnames(env_dataset.(map));  % Get subject names within each map

        for j = 1:length(subs)
            sub = subs{j};

            rov_traces = env_dataset.(map).(sub).rov_trace;  % Extract rov_trace signals
            [M, N] = size(rov_traces);

            for k = 1:N
                rov_trace = rov_traces{:, k};
                
                % Compute envelope features using compute_envelope_features
                [n_peaks, peak1_pos, peak2_pos, peak3_pos, peak1_val, peak2_val, peak3_val, ...
                    duration, silent_phase, silent_rateo, major_peaks_rateo, n_peaks_duration_rateo] = ...
                    compute_envelope_features(rov_trace, fc);

                % Append the computed features as a row in envelope_features
                envelope_features = [envelope_features; n_peaks, peak1_pos, peak2_pos, peak3_pos, ...
                    peak1_val, peak2_val, peak3_val, duration, silent_phase, silent_rateo, ...
                    major_peaks_rateo, n_peaks_duration_rateo, map];
            end
        end
    end

    % Convert envelope_features to a table and assign column names (using cell array format)
    envelope_features = array2table(envelope_features, 'VariableNames', ...
        {'n_peaks', 'peak1_pos', 'peak2_pos', 'peak3_pos', 'peak1_val', ...
        'peak2_val', 'peak3_val', 'duration', 'silent_phase', 'silent_rateo', ...
        'major_peaks_rateo', 'n_peaks_duration_rateo', 'class'});
end
