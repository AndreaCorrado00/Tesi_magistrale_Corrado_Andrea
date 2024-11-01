function newData = find_guide_trace_and_filter(data, Fc, filter)
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

            % Get size of rov_trace to know number of rows and columns
            [M, N] = size(data.(mapName).(subjectName).rov_trace);

            % Initialize matrices for filtered data
            rov_filtered = zeros(M, N);
            ref_filtered = zeros(M, N);
            spare1_filtered = zeros(M, N);
            spare2_filtered = zeros(M, N);
            spare3_filtered = zeros(M, N);

            % Apply filtering if specified
            if filter
                for k = 1:N
                    % Extract each trace column as a vector and remove mean
                    rov = data.(mapName).(subjectName).rov_trace{:, k} - mean(data.(mapName).(subjectName).rov_trace{:, k});
                    ref = data.(mapName).(subjectName).ref_trace{:, k} - mean(data.(mapName).(subjectName).ref_trace{:, k});
                    spare1 = data.(mapName).(subjectName).spare1_trace{:, k} - mean(data.(mapName).(subjectName).spare1_trace{:, k});
                    spare2 = data.(mapName).(subjectName).spare2_trace{:, k} - mean(data.(mapName).(subjectName).spare2_trace{:, k});
                    spare3 = data.(mapName).(subjectName).spare3_trace{:, k} - mean(data.(mapName).(subjectName).spare3_trace{:, k});

                    % Apply the denoise filter to each trace
                    rov_filtered(:, k) = handable_denoise_ecg_BP(rov, Fc, 2, 100);
                    ref_filtered(:, k) = handable_denoise_ecg_BP(ref, Fc, 2, 100);
                    spare1_filtered(:, k) = handable_denoise_ecg_BP(spare1, Fc, 2, 60);
                    spare2_filtered(:, k) = handable_denoise_ecg_BP(spare2, Fc, 2, 60);
                    spare3_filtered(:, k) = handable_denoise_ecg_BP(spare3, Fc, 2, 60);
                end

                % Store filtered data in newData as tables
                newData.(mapName).(subjectName).rov_trace = array2table(rov_filtered);
                newData.(mapName).(subjectName).ref_trace = array2table(ref_filtered);
                newData.(mapName).(subjectName).spare1_trace = array2table(spare1_filtered);
                newData.(mapName).(subjectName).spare2_trace = array2table(spare2_filtered);
                newData.(mapName).(subjectName).spare3_trace = array2table(spare3_filtered);
            end
        end
    end

    % Loop through each map (e.g., MAP_A, MAP_B, MAP_C) to determine guide traces and R peaks
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});  % Construct the map name

        % Loop through each subject within the current map
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name

            % Determine guide trace based on strategy
            guide_trace = decide_strategy(newData.(mapName).(subjectName).traces_origin);

            % Extract the guide signals from the newData structure
            rovSignals = newData.(mapName).(subjectName).rov_trace;
            guideSignals = newData.(mapName).(subjectName).(guide_trace);

            R_peaks = cell(1, width(rovSignals));  % Initialize cell array for R peaks

            % Loop through each signal (column) in the rovSignals table
            for k = 1:width(rovSignals)
                guideSignal = guideSignals{:, k};  % Extract the corresponding guide signal

                % Define the QRS position based on the maximum value in guideSignals centered at 0.5 seconds
                center_time = 0.5;  % Center point in seconds
                center_sample = round(center_time * Fc);  % Convert to sample index

                % Define the neighborhood in seconds and convert to sample indices
                neighborhood_seconds = 0.3;
                neighborhood_samples = round(neighborhood_seconds * Fc);

                % Calculate the range for the QRS search
                search_start = max(center_sample - neighborhood_samples, 1);
                search_end = min(center_sample + neighborhood_samples, length(guideSignal));

                % Find the QRS position by locating the maximum in the neighborhood
                [~, local_max_index] = max(abs(guideSignal(search_start:search_end)));
                R_peak = local_max_index + search_start - 1;  % Adjust index back to the original signal

                R_peaks{k} = R_peak;
            end

            % Save QRS position information and guide trace name
            newData.(mapName).(subjectName).R_peaks = R_peaks;
            newData.(mapName).(subjectName).guide_trace = guide_trace;
        end
    end
end
