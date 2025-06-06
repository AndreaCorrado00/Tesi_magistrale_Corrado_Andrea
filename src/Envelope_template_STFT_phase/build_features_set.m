function envelope_features = build_features_set(data, env_data, TM_1_data, TM_2_data, fc)
% build_features_set - Computes a comprehensive set of features from envelope data,
% template matching results, and additional signal processing techniques.
%
% INPUTS:
%   data        - Struct containing raw signal data for each map type and subject.
%   env_data    - Struct containing envelope data corresponding to the raw signals.
%   TM_1_data   - Struct containing Template Matching 1 data for cross-correlation.
%   TM_2_data   - Struct containing Template Matching 2 data for cross-correlation.
%   fc          - Cutoff frequency for signal processing (e.g., for filtering or FFT).
%
% OUTPUT:
%   envelope_features - A table containing the computed feature set for each signal.
%                       Each row represents a signal, and columns include various
%                       signal properties, such as peak values, time, and other derived features.

% Initialize a cell array to store rows of the feature table
features_rows = [];

% Create a dictionary to map map codes to names
map_codes = ["MAP_A", "MAP_B", "MAP_C"];
map_names = ["Indifferent", "Effective", "Dangerous"];
class_dict = containers.Map(map_codes, map_names);

% Loop through each map type (A, B, C) to compute features for each subject
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    
    % Get the list of subjects for the current map
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j =1:length(subjects)
        sub = subjects{j};

        % Get the number of signals for the current subject
        [~, N] = size(data.(map).(sub).rov_trace);

        % Extract the subject number from the subject identifier
        sub_num = split(sub, '_');
        sub_num = split(sub_num{2}, i);
        sub_num = sub_num{end};
        
        % Loop through each signal for the subject
        for h = 1:N
            % Extract the raw signal, envelope data, and corresponding template matching data
            example_rov = data.(map).(sub).rov_trace{:, h};
            example_env = env_data.(map).(sub).rov_trace{:, h};
            example_corr_TM_1 = TM_1_data.(map).(sub).rov_trace{:, h};
            example_corr_TM_2 = TM_2_data.(map).(sub).rov_trace{:, h};
            T = TM_1_data.T;

            disp([sub + "-" + num2str(h)])

            %% Compute envelope features
            % Extract a comprehensive set of features from the envelope signal
            [active_areas_number, Dominant_peak, Dominant_peak_time, ...
                Subdominant_peak, Subdominant_peak_time, Minor_peak, Minor_peak_time, ...
                Dominant_peak_env, Dominant_peak_env_time, Subdominant_peak_env, ...
                Subdominant_peak_env_time, Minor_peak_env, Minor_peak_env_time, ...
                First_peak, First_peak_time, Second_peak, Second_peak_time, ...
                Third_peak, Third_peak_time, First_peak_env, First_peak_env_time, ...
                Second_peak_env, Second_peak_env_time, Third_peak_env, Third_peak_env_time, ...
                duration, silent_phase, silent_rateo, atrial_ventricular_ratio, ...
                atrial_ventricular_time_ratio, minor_to_major_ratio, ...
                minor_to_subdominant_ratio, n_active_areas_on_duration_ratio] = ...
                compute_envelope_features(example_env, example_rov, fc);

            %% Compute Template Matching features
            % Perform template matching and extract cross-correlation features
            record_id = [i, sub_num, h];
            [cross_peak_1, cross_peak_pos_1, corr_energy_1, ...
                cross_peak_2, cross_peak_pos_2, corr_energy_2] = ...
                compute_TM_features(record_id, data, env_data, example_corr_TM_1, ...
                example_corr_TM_2, T, fc);

            %% Compute additional signal features
            % Fragmentation, ApEn, and other signal-specific features
            Fragmentation = compute_fragmentation_value(example_rov, 0.750, fc); % Baldazzi et al.
            App = compute_pp_amplitude(example_rov, fc); % Baldazzi et al.

            % Compute spectral features using Short Time Fourier Transform (STFT)
            [Dominant_ALFP, Dominant_AMFP, Dominant_AHFP, ...
            Subdominant_ALFP, Subdominant_AMFP, Subdominant_AHFP, ...
            Minor_ALFP, Minor_AMFP, Minor_AHFP,...
            First_ALFP, First_AMFP,First_AHFP, ...
            Second_ALFP, Second_AMFP, Second_AHFP, ...
            Third_ALFP, Third_AMFP, Third_AHFP,...
            max_First_HF,max_First_MF,max_First_LF,...
            max_Second_HF,max_Second_MF,max_Second_LF,...
            max_Third_HF,max_Third_MF,max_Third_LF,...
            min_First_HF,min_First_MF,min_First_LF,...
            min_Second_HF,min_Second_MF,min_Second_LF,...
            min_Third_HF,min_Third_MF,min_Third_LF,...
            std_First_HF,std_First_MF,std_First_LF,...
            std_Second_HF,std_Second_MF,std_Second_LF,...
            std_Third_HF,std_Third_MF,std_Third_LF] = ...
                compute_STFT_features(example_rov, example_env, fc);

            % Create a row for the current signal with all computed features
            feature_row = {
                string(sub_num), string(active_areas_number), string(Dominant_peak), string(Dominant_peak_time), ...
                string(Subdominant_peak), string(Subdominant_peak_time), string(Minor_peak), string(Minor_peak_time), ...
                string(Dominant_peak_env), string(Dominant_peak_env_time), string(Subdominant_peak_env), ...
                string(Subdominant_peak_env_time), string(Minor_peak_env), string(Minor_peak_env_time), ...
                string(First_peak), string(First_peak_time), string(Second_peak), string(Second_peak_time), ...
                string(Third_peak), string(Third_peak_time), string(First_peak_env), string(First_peak_env_time), ...
                string(Second_peak_env), string(Second_peak_env_time), string(Third_peak_env), string(Third_peak_env_time), ...
                string(duration), string(silent_phase), string(silent_rateo), string(atrial_ventricular_ratio), ...
                string(atrial_ventricular_time_ratio), string(minor_to_major_ratio), string(minor_to_subdominant_ratio), ...
                string(n_active_areas_on_duration_ratio), string(cross_peak_1), string(cross_peak_pos_1), ...
                string(corr_energy_1), string(cross_peak_2), string(cross_peak_pos_2), string(corr_energy_2), ...
                string(Dominant_ALFP), string(Dominant_AMFP), string(Dominant_AHFP), string(Subdominant_ALFP), string(Subdominant_AMFP), ...
                string(Subdominant_AHFP), string(Minor_ALFP), string(Minor_AMFP), string(Minor_AHFP), string(First_ALFP), ...
                string(First_AMFP), string(First_AHFP), string(Second_ALFP), string(Second_AMFP), string(Second_AHFP), ...
                string(Third_ALFP), string(Third_AMFP), string(Third_AHFP), ...
                string(max_First_HF), string(max_First_MF), string(max_First_LF), ...
                string(max_Second_HF), string(max_Second_MF), string(max_Second_LF), ...
                string(max_Third_HF), string(max_Third_MF), string(max_Third_LF), ...
                string(min_First_HF), string(min_First_MF), string(min_First_LF), ...
                string(min_Second_HF), string(min_Second_MF), string(min_Second_LF), ...
                string(min_Third_HF), string(min_Third_MF), string(min_Third_LF), ...
                string(std_First_HF), string(std_First_MF), string(std_First_LF), ...
                string(std_Second_HF), string(std_Second_MF), string(std_Second_LF), ...
                string(std_Third_HF), string(std_Third_MF), string(std_Third_LF),string(Fragmentation), string(App), ...
                class_dict(map) % Add the "class" column with the map identifier
            };

            % Append the current row to the dataset
            features_rows = [features_rows; feature_row];
        end
    end
end

% Convert the cell array to a table with descriptive column names
envelope_features = cell2table(features_rows, ...
    'VariableNames', {'id', 'active_areas_number', 'Dominant_peak', 'Dominant_peak_time', ...
    'Subdominant_peak', 'Subdominant_peak_time', 'Minor_peak', 'Minor_peak_time', ...
    'Dominant_peak_env', 'Dominant_peak_env_time', 'Subdominant_peak_env', ...
    'Subdominant_peak_env_time', 'Minor_peak_env', 'Minor_peak_env_time', 'First_peak', ...
    'First_peak_time', 'Second_peak', 'Second_peak_time', 'Third_peak', 'Third_peak_time', ...
    'First_peak_env', 'First_peak_env_time', 'Second_peak_env', 'Second_peak_env_time', ...
    'Third_peak_env', 'Third_peak_env_time', 'duration', 'silent_phase', 'silent_rateo', ...
    'atrial_ventricular_ratio', 'atrial_ventricular_time_ratio', 'minor_to_dominant_ratio', ...
    'minor_to_subdominant_ratio', 'n_active_areas_on_duration_ratio', 'cross_peak_TM1', ...
    'cross_peak_time_TM1', 'cross_energy_TM1', 'cross_peak_TM2', 'cross_peak_time_TM2', ...
    'cross_energy_TM2', 'Dominant_AvgPowLF', 'Dominant_AvgPowMF', 'Dominant_AvgPowHF', ...
    'Subdominant_AvgPowLF', 'Subdominant_AvgPowMF', 'Subdominant_AvgPowHF', 'Minor_AvgPowLF', ...
    'Minor_AvgPowMF', 'Minor_AvgPowHF', 'First_AvgPowLF', 'First_AvgPowMF', 'First_AvgPowHF', ...
    'Second_AvgPowLF', 'Second_AvgPowMF', 'Second_AvgPowHF', 'Third_AvgPowLF', 'Third_AvgPowMF', ...
    'Third_AvgPowHF', ...
    'First_Active_Area_max_Power_HF','First_Active_Area_max_Power_MF','First_Active_Area_max_Power_LF', ...
    'Second_Active_Area_max_Power_HF','Second_Active_Area_max_Power_MF','Second_Active_Area_max_Power_LF', ...
    'Third_Active_Area_max_Power_HF','Third_Active_Area_max_Power_MF','Third_Active_Area_max_Power_LF', ...
    'First_Active_Area_min_Power_HF','First_Active_Area_min_Power_MF','First_Active_Area_min_Power_LF', ...
    'Second_Active_Area_min_Power_HF','Second_Active_Area_min_Power_MF','Second_Active_Area_min_Power_LF', ...
    'Third_Active_Area_min_Power_HF','Third_Active_Area_min_Power_MF','Third_Active_Area_min_Power_LF', ...
    'First_Active_Area_Power_std_HF','First_Active_Area_Power_std_MF','First_Active_Area_Power_std_LF', ...
    'Second_Active_Area_Power_std_HF','Second_Active_Area_Power_std_MF','Second_Active_Area_Power_std_LF', ...
    'Third_Active_Area_Power_std_HF','Third_Active_Area_Power_std_MF','Third_Active_Area_Power_std_LF', ...
    'Fragmentation', 'App', 'class'});

end
