function show_QRS_positions(data, Fc)
    % Function to plot QRS positions and values for each subject across different traces and maps.
    %
    % INPUTS:
    %   data - Structured data containing QRS position and trace information
    %   Fc - Sampling frequency for normalization of QRS positions
    %
    % OUTPUT:
    %   None. The function displays a figure with QRS positions and values.

    % Define MAP names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};
    
    % Number of subjects (assumed to be 12)
    numSubjects = 12;
    
    % Colors for subjects (avoid repetition)
    colors = lines(numSubjects);  % Generate unique colors for each subject

    % Initialize figure
    figure;
    
    % Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});  % Construct the map name
        
        % Loop through each subject within the current map
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name
            
            % Extract QRS positions and convert to numeric arrays
            QRS_pos_ref = cell2mat(impute_QRS_pos(data.(mapName).(subjectName).QRS_position_ref_trace));
            QRS_pos_spare1 = cell2mat(impute_QRS_pos(data.(mapName).(subjectName).QRS_position_spare1_trace));
            QRS_pos_spare2 = cell2mat(impute_QRS_pos(data.(mapName).(subjectName).QRS_position_spare2_trace));

            % Extraction of QRS values
            QRS_values_ref = [];
            QRS_values_spare1 = [];
            QRS_values_spare2 = [];

            ref_trace = table2array(data.(mapName).(subjectName).ref_trace);
            spare1_trace = table2array(data.(mapName).(subjectName).spare1_trace);
            spare2_trace = table2array(data.(mapName).(subjectName).spare2_trace);

            [~, N] = size(ref_trace);

            for k = 1:N
                QRS_values_ref = [QRS_values_ref; ref_trace(QRS_pos_ref(k))];
                QRS_values_spare1 = [QRS_values_spare1; spare1_trace(QRS_pos_spare1(k))];
                QRS_values_spare2 = [QRS_values_spare2; spare2_trace(QRS_pos_spare2(k))];
            end

            % Normalize QRS positions by Fc
            QRS_pos_ref = QRS_pos_ref ./ Fc;
            QRS_pos_spare1 = QRS_pos_spare1 ./ Fc;
            QRS_pos_spare2 = QRS_pos_spare2 ./ Fc;
            
            % Define subplots
            fig = figure(1);
            fig.WindowState = "maximized";

            Traces = ["ref trace", "spare1 trace", "spare2 trace"];
            
            % Row 1: ref_trace, Row 2: spare1_trace, Row 3: spare2_trace
            for traceIdx = 1:3
                subplot(3, length(mapNames), (traceIdx - 1) * length(mapNames) + i);
                xlim([0, 1])
                xlabel('QRS Positions (s)');
                ylabel('QRS Values');
                
                % Select the correct QRS positions and values for each trace
                if traceIdx == 1
                    QRS_pos = QRS_pos_ref;
                    QRS_values = QRS_values_ref;
                elseif traceIdx == 2
                    QRS_pos = QRS_pos_spare1;
                    QRS_values = QRS_values_spare1;
                else
                    QRS_pos = QRS_pos_spare2;
                    QRS_values = QRS_values_spare2;
                end
                
                % Plot the QRS positions
                hold on;
                plot(QRS_pos, QRS_values, '+', 'Color', colors(j, :));  % Subject points with '+'
                
                % Highlight median value with a larger circle
                medIdx = floor(length(QRS_pos) / 2) + 1;  % Median index
                plot(QRS_pos(medIdx), QRS_values(medIdx), 'o', 'MarkerSize', 4, ...
                    'MarkerEdgeColor', 'k', 'MarkerFaceColor', colors(j, :));  % Circle for median

                % Set axis labels and titles for the first row and first column
                if traceIdx == 1
                    title(['MAP ' mapNames{i}]);  % Title for each map column
                end
                if i == 1
                    ylabel([Traces(traceIdx)], "FontWeight", "bold");  % Label for each trace row
                end
            end
        end
    end
    
    sgtitle('QRS Positions and Values for all Subjects across Traces and Maps');
end
