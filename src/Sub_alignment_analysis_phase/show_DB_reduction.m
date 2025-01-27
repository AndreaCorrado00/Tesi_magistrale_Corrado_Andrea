function show_DB_reduction(data)
% This function performs a reduction in the database by filtering out
% subjects whose reference trace is not ECG, and calculates the statistics
% of the reduction in terms of the number of subjects and signals.
%
% Parameters:
%   data (struct): The dataset containing the traces for multiple subjects.
%                  The dataset is organized into different maps (MAP_A, MAP_B, MAP_C),
%                  and each subject has various traces such as "rov_trace", "ref_trace", etc.

    % Define map names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};
    
    % Number of subjects (assumed to be 12)
    numSubjects = 12;

    %% Step 1: Build a subset of the database with reference traces as ECG
    refECG_data = struct;  % Initialize a structure to hold filtered data
    
    % Initialize the original cardinalities (number of signals) for each map
    MAPs_cardinalities_original = [0, 0, 0];  % MAP_A, MAP_B, MAP_C

    % Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});  % Construct the map name

        % Loop through each subject within the current map
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name
            
            % Get the trace guide (whether it's a ref_trace or not)
            guide_trace = decide_strategy(data.(mapName).(subjectName).traces_origin);

            % Update the original signal count (excluding subject 5)
            if j ~= 5
                [~, M] = size(data.(mapName).(subjectName).rov_trace);
                MAPs_cardinalities_original(i) = MAPs_cardinalities_original(i) + M;
            end

            % If the guide trace is a reference ECG trace, store the subject data
            if guide_trace == "ref_trace"
                refECG_data.(mapName).(subjectName) = data.(mapName).(subjectName);
            end
        end
    end

    %% Step 2: Calculate statistics of the database reduction
    n_sub_red = length(fieldnames(refECG_data.MAP_A));  % Number of remaining subjects after reduction

    % Display the number of remaining subjects
    fprintf("Remaining subjects are: %d with n signals: \n", n_sub_red);

    % Initialize the reduced signal cardinalities for each map
    MAPs_cardinalities_reduced = [0, 0, 0];  % MAP_A, MAP_B, MAP_C

    % Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});  % Construct the map name
        subjects = fieldnames(refECG_data.(mapName));  % Get subjects for the current map

        % Loop through each subject in the reduced database
        for j = 1:length(subjects)
            subjectName = subjects{j};  % Get the subject name

            % Check if the subject is not the excluded subject (subject 5)
            sub_idx = strsplit(subjectName, "_");
            sub_idx = string(sub_idx(2));
            last_char = sub_idx{1}(end);

            if str2double(last_char) ~= 5  % Exclude subject 5
                [~, M] = size(refECG_data.(mapName).(subjectName).rov_trace);
                MAPs_cardinalities_reduced(i) = MAPs_cardinalities_reduced(i) + M;
            end
        end
    end

    % Display the statistics of database reduction
    fprintf("   MAP_A: %d from %d\n", MAPs_cardinalities_reduced(1), MAPs_cardinalities_original(1));
    fprintf("   MAP_B: %d from %d\n", MAPs_cardinalities_reduced(2), MAPs_cardinalities_original(2));
    fprintf("   MAP_C: %d from %d\n", MAPs_cardinalities_reduced(3), MAPs_cardinalities_original(3));

end
