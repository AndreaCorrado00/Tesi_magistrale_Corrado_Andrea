function plotQRSForSubjects(data, subjectIndices, Fc)
% plotQRSForSubjects - Plots the ref_trace signals and corresponding QRS points for specified subjects.
% Each signal and its QRS points are plotted with the same color.
%
% Syntax: plotQRSForSubjects(data, subjectIndices, Fc)
%
% Inputs:
%    data - Input dataset structured as described, with QRS_position fields
%    subjectIndices - Array of indices indicating which subjects to investigate (e.g., [1, 3, 5])
%    Fc - Sampling frequency (Hz)
%
% Outputs:
%    None (Plots figures directly)

    % Define MAP names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};
    
    % Number of subjects
    numSubjects = 12;
    
    % Define a set of colors for plotting
    colors = lines(7); % Use a limited palette of colors (e.g., 7 distinct colors)
    
    % Loop through each selected subject
    for idx = 1:length(subjectIndices)
        subjectNum = subjectIndices(idx);
        
        % Create a new figure for each subject
        figure;
        
        % Loop through each map (MAP_A, MAP_B, MAP_C)
        for i = 1:length(mapNames)
            mapName = 'MAP_' + string(mapNames{i});
            subjectName = sprintf('%s%d', mapName, subjectNum);
            
            % Extract the reference signals and QRS positions
            refSignals = data.(mapName).(subjectName).ref_trace;
            QRS_positions = data.(mapName).(subjectName).QRS_position;
            
            % Create subplot for the current map
            subplot(1, 3, i);
            hold on;
            
            % Plot each signal with its corresponding QRS points
            numSignals = width(refSignals);
            for k = 1:numSignals
                signal = refSignals{:, k};
                QRS_pos = QRS_positions{k};
                
                % Determine color index (cycle through available colors)
                colorIdx = mod(k-1, size(colors, 1)) + 1;
                color = colors(colorIdx, :);
                
                % Plot signal
                plot((1:length(signal)) / Fc, signal, 'Color', color);
                
                % Plot QRS points
                plot(QRS_pos / Fc, signal(QRS_pos), 'o', 'Color', color);
            end
            
            % Title and labels for subplot
            title(sprintf('Map %s', mapNames{i}));
            xlabel('Time (s)');
            ylabel('Amplitude');
            hold off;
        end
        
        % Adjust figure layout
        sgtitle(sprintf('Subject %d', subjectNum)); % Title for the whole figure
    end
end


