function QRSStatsTable = computeQRSStatistics(data)
% computeQRSStatistics - Computes the mean, variability, extreme values, and
% signal count of QRS positions for each subject and returns a table with these statistics.
%
% Syntax: QRSStatsTable = computeQRSStatistics(data)
%
% Inputs:
%    data - Input dataset structured as described, with QRS_position fields
%
% Outputs:
%    QRSStatsTable - Table with rows representing subjects and columns representing 
%                    mean QRS position, variability, extreme values, and signal count for each map (MAP_A, MAP_B, MAP_C)

    % Define MAP names (MAP_A, MAP_B, MAP_C)
    mapNames = {'MAP_A', 'MAP_B', 'MAP_C'};
    
    % Number of subjects
    numSubjects = 12;
    
    % Initialize arrays to store the computed statistics
    meanQRS = zeros(numSubjects, length(mapNames));
    variabilityQRS = zeros(numSubjects, length(mapNames));
    minQRS = zeros(numSubjects, length(mapNames));
    maxQRS = zeros(numSubjects, length(mapNames));
    signalCount = zeros(numSubjects, 1);
    
    % Loop through each map
    for i = 1:length(mapNames)
        mapName = mapNames{i};
        
        % Loop through each subject (MAP_A1, MAP_A2, ..., MAP_C12)
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);
            
            % Extract QRS positions for the current subject
            QRS_positions = data.(mapName).(subjectName).QRS_position;
            
            % Combine QRS positions from all signals into a single array
            allQRSPositions = [];
            for k = 1:length(QRS_positions)
                allQRSPositions = [allQRSPositions; QRS_positions{k}];
            end
            
            % Calculate mean, variability (standard deviation), and extreme values
            meanQRS(j, i) = round(mean(allQRSPositions)); % Mean QRS position
            variabilityQRS(j, i) = 2 * std(allQRSPositions); % Variability (± 2 * std)
            minQRS(j, i) = min(allQRSPositions); % Minimum QRS position
            maxQRS(j, i) = max(allQRSPositions); % Maximum QRS position
            
            % Count the number of signals for this subject (allQRSPositions might be empty)
            if i == 1  % Only need to count once per subject
                signalCount(j) = length(QRS_positions);
            end
        end
    end
    
    % Construct the table with appropriate column names
    QRSStatsTable = table(...
        meanQRS(:,1), variabilityQRS(:,1), minQRS(:,1), maxQRS(:,1), ...
        meanQRS(:,2), variabilityQRS(:,2), minQRS(:,2), maxQRS(:,2), ...
        meanQRS(:,3), variabilityQRS(:,3), minQRS(:,3), maxQRS(:,3), ...
        signalCount, ...
        'VariableNames', {'MAP_A_Mean', 'MAP_A_Variability', 'MAP_A_Min', 'MAP_A_Max', ...
                          'MAP_B_Mean', 'MAP_B_Variability', 'MAP_B_Min', 'MAP_B_Max', ...
                          'MAP_C_Mean', 'MAP_C_Variability', 'MAP_C_Min', 'MAP_C_Max', ...
                          'Signal_Count'});
    
    % Add row names corresponding to the subject names (MAP_A1, MAP_A2, ..., MAP_C12)
    subjectNames = arrayfun(@(n) sprintf('Subject_%d', n), 1:numSubjects, 'UniformOutput', false);
    QRSStatsTable.Properties.RowNames = subjectNames;
end

