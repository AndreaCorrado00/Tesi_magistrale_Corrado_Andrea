function newData = find_guide_trace(data, Fc)

% Initialize newData as a copy of the input data
newData = data;

% Define MAP names (MAP_A, MAP_B, MAP_C)
mapNames = {'A', 'B', 'C'};

% Number of subjects (assumed to be 12)
numSubjects = 12;

% Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
for i = 1:length(mapNames)
    mapName = 'MAP_' + string(mapNames{i});  % Construct the map name

    % Loop through each subject within the current map
    for j = 1:numSubjects
        subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name

        guide_trace=decide_strategy(newData.(mapName).(subjectName).traces_origin);

        % Extract the rov and reference signals from the data structure
        % rovSignals = newData.(mapName).(subjectName).rov_trace;
        guideSignals = newData.(mapName).(subjectName).(guide_trace);
        % FP_positions={};
        R_peaks={};
        % Loop through each signal (column) in the rovSignals table
        for k = 1:width(rovSignals)
            % signal = rovSignals{:, k};  % Extract the k-th signal from the rov trace
            % half_width = round((Fc * window) / 2);  % Calculate half of the alignment window in samples
            guideSignals = guideSignals{:, k};  % Extract the corresponding guide signal

            % Define the QRS position based on the maximum value in guideSignals
            % centered around 0.5 seconds from the start of the signal
            center_time = 0.5;  % Center point in seconds
            center_sample = round(center_time * Fc);  % Convert to sample index

            % Define the neighborhood in seconds
            neighborhood_seconds = 0.3;
            % Convert the neighborhood to sample indices
            neighborhood_samples = round(neighborhood_seconds * Fc);  % Fs is the sampling frequency in Hz

            % Calculate the range for the QRS search
            search_start = max(center_sample - neighborhood_samples, 1);  % Ensure we don't go below index 1
            search_end = min(center_sample + neighborhood_samples, length(guideSignals));  % Ensure we don't exceed signal length

            % Find the QRS position by looking for the maximum in the defined neighborhood
            [~, local_max_index] = max(abs(guideSignals(search_start:search_end)));  % Find the maximum in the neighborhood
            R_peak = local_max_index + search_start - 1;  % Adjust index back to the original signal

            % Alignment and fiducial point
            % [FP_pos, new_rov] = align_to_QRS(signal, QRS_pos, half_width);
            % Saving rov trace
            % rovSignals{:, k} = new_rov;
            % Saving FP position
            % FP_positions{k} = FP_pos;
            R_peaks{k} = R_peak;
        end


        % Save the alisgned rov signals back into the data structure
            % newData.(mapName).(subjectName).rov_trace = rovSignals;
            % newData.(mapName).(subjectName).FP_position_rov = FP_positions;

            % Saving QRS position informations
            QRS_pos_fiel_name="R_peaks"+guide_trace;
            newData.(mapName).(subjectName).(QRS_pos_fiel_name)=R_peaks;
            % newData.(mapName).(subjectName).alignment_trace=trace_align;
        %     % Switch based on the selected alignment strategy
        % 
        % % Save the updated QRS positions based on the strategy used
        % switch strategy
        %     case 'only_ref'
        %         newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
        %     case 'ref_and_spare2'
        %         newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
        %         newData.(mapName).(subjectName).QRS_position_spare2_trace = QRSpositions_spare2;
        %     case 'only_spare1'
        %         newData.(mapName).(subjectName).QRS_position_spare1_trace = QRSpositions_spare1;
        %     case 'spare2_and_spare1'
        %         newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
        %         newData.(mapName).(subjectName).QRS_position_spare2_trace = QRSpositions_spare2;
        %         newData.(mapName).(subjectName).QRS_position_spare1_trace = QRSpositions_spare1;
        % end
    end
end
end
