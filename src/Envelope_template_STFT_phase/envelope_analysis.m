function envelope_features = envelope_analysis(env_dataset, fc)
    % The function computes various envelope features from a given dataset of ROV traces.
    % It iterates over a dataset structure and computes features for each ROV trace 
    % from different subject groups, and returns them in a table.
    %
    % Inputs:
    % - env_dataset: A structure containing data for different maps and subjects.
    %                 Each subject has ROV traces that will be analyzed.
    % - fc: The sampling frequency of the ROV traces.
    %
    % Output:
    % - envelope_features: A table containing computed envelope features for each ROV trace.

    % Initialize an empty matrix to store the features
    envelope_features = [];  

    % Define map categories to iterate through
    maps = ["MAP_A", "MAP_B", "MAP_C"];  

    for i = 3  % Iterate over map categories (currently only 'MAP_C' for simplicity)
        map = maps(i);  % Select the map based on the index
        subs = fieldnames(env_dataset.(map));  % Get the list of subjects for the current map

        for j = 7  % Iterate over selected subjects (currently only the 7th subject for simplicity)
            sub = subs{j};  % Select the subject

            % Extract the ROV trace data for the subject
            rov_traces = env_dataset.(map).(sub).rov_trace;  
            [M, N] = size(rov_traces);  % Get the size of the ROV traces array

            for k = 1:N  % Iterate over each ROV trace (N total)
                rov_trace = rov_traces{:, k};  % Select the k-th ROV trace

                % Compute the envelope features for the current ROV trace
                % Using the function compute_envelope_features_C (not provided here)
                [n_peaks, peak1_pos, peak2_pos, peak3_pos, peak1_val, peak2_val, peak3_val, ...
                    duration, silent_phase, silent_rateo, major_peaks_rateo, n_peaks_duration_rateo] = ...
                    compute_envelope_features_C(rov_trace, fc);

                % Append the computed features as a new row in the envelope_features matrix
                envelope_features = [envelope_features; n_peaks, peak1_pos, peak2_pos, peak3_pos, ...
                    peak1_val, peak2_val, peak3_val, duration, silent_phase, silent_rateo, ...
                    major_peaks_rateo, n_peaks_duration_rateo, map];  % Add map as a class label
            end
        end
    end

    % Convert the envelope_features matrix into a table and assign appropriate column names
    envelope_features = array2table(envelope_features, 'VariableNames', ...
        {'n_peaks', 'peak1_pos', 'peak2_pos', 'peak3_pos', 'peak1_val', ...
        'peak2_val', 'peak3_val', 'duration', 'silent_phase', 'silent_rateo', ...
        'major_peaks_rateo', 'n_peaks_duration_rateo', 'class'});
end
