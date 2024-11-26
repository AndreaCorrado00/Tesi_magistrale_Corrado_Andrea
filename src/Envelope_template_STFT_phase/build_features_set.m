function envelope_features = build_features_set(data, env_data, fc)

% Initialize a cell array to store rows of the feature table
features_rows = [];

% Loop through each map type: MAP_A, MAP_B, MAP_C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = subjects{j};

        % Get the number of signals for the current subject
        [~, N] = size(data.(map).(sub).rov_trace);

        sub_num=split(sub,'_');
        sub_num=split(sub_num{2},i);
        sub_num=sub_num{end};
        for h = 1:N
            % Extract the rov_trace signal and its corresponding envelope
            example_rov = data.(map).(sub).rov_trace{:,h};
            example_env = env_data.(map).(sub).rov_trace{:,h};

            disp([sub+"-"+num2str(h)])

            % Compute features using the compute_envelope_features function
            % disp([sub+"-"+num2str(h)])
            [n_peaks,env_peak1_pos,env_peak2_pos,env_peak3_pos,env_peak1_val,env_peak2_val,env_peak3_val,...
    peak1_pos,peak2_pos,peak3_pos,peak1_val,peak2_val,peak3_val,...
    duration,silent_phase,silent_rateo,atrial_ventricular_ratio,...
    atrial_ventricular_time_ratio,third_major_ratio,third_second_ratio,n_peaks_duration_ratio] = ...
    compute_envelope_features(example_env, example_rov, fc);

            [cross_peak,cross_peak_pos]=compute_TM_features(example_rov,0.01, fc);

            % Save the computed features as strings (to handle NaN values)
            feature_row = {
                string(sub_num),...
                string(n_peaks), string(env_peak1_pos), string(env_peak2_pos), string(env_peak3_pos), ...
                string(env_peak1_val), string(env_peak2_val), string(env_peak3_val),...
                string(peak1_pos), string(peak2_pos), string(peak3_pos), ...
                string(peak1_val), string(peak2_val), string(peak3_val), ...
                string(duration), string(silent_phase), string(silent_rateo), ...
                string(atrial_ventricular_ratio),string(atrial_ventricular_time_ratio),...
                string(third_major_ratio),string(third_second_ratio), string(n_peaks_duration_ratio), ...
                string(cross_peak),string(cross_peak_pos),map % Add the "class" column with the map identifier
            };

            % Append the current row to the dataset
            features_rows = [features_rows; feature_row];
        end
    end
end

% Create the final table with column names
envelope_features = cell2table(features_rows, ...
    'VariableNames', {'id','N_peaks', 'env_peak1_pos', 'env_peak2_pos', 'env_peak3_pos','env_peak1_val', 'env_peak2_val', 'env_peak3_val', ...
    'peak1_pos', 'peak2_pos', 'peak3_pos','peak1_val', 'peak2_val', 'peak3_val',...
    'duration', 'silent_phase', ...
    'silent_rateo', 'atrial_ventricular_ratio', 'atrial_ventricular_time_ratio',...
    'third_major_ratio','third_second_ratio','n_peaks_duration_rateo',...
    'cross_peak','cross_peak_pos','class'});

end
