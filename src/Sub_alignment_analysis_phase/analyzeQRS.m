function newData = analyzeQRS(data, Fc,plotFlag,signal_name)
% analyzeQRS - Analyzes all signals in the ref fields of the data structure using the
% Pan-Tompkins algorithm to detect QRS complexes and stores their positions.
%
% Syntax: newData = analyzeQRS(data, Fc)
%
% Inputs:
%    data - Input dataset structured as described
%    Fc - Sampling frequency (Hz)
%
% Outputs:
%    newData - Modified dataset with QRS_position field added

    % Initialize newData as a copy of the input data
    newData = data;

    % Define MAP names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};
    
    % Number of subjects
    numSubjects = 12;
    
    % Loop through each map
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});
        
        % Loop through each subject (MAP_A1, MAP_A2, ..., MAP_C12)
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);
            
            % Extract the reference signals (assumed to be a table)
            refSignals = newData.(mapName).(subjectName).(signal_name);
            
            % Initialize cell array to store QRS positions for each signal
            QRS_positions = cell(1, width(refSignals));
            
            % Loop through each signal in the reference table
            for k = 1:width(refSignals)
                signal = refSignals{:, k};
                
                % Detect QRS positions using Pan-Tompkins algorithm
                QRS_positions{k} = detectQRS(signal, Fc);
                
                % Plot the first signal with QRS positions if plotFlag is true
                if plotFlag && j == 1 && k == 1
                    figure;
                    plot((1:length(signal))/Fc, signal);
                    hold on;
                    plot(QRS_positions{k}/Fc, signal(QRS_positions{k}), 'ro');
                    xlabel('Time (s)');
                    ylabel('Amplitude');
                    title_plot='First ref Signal with Detected QRS Positions for MAP: '+ string(mapNames{i})+', sub: '+num2str(j);
                    title(title_plot);
                    legend('ECG Signal', 'QRS Positions');
                    hold off;
                end
            end

            name_of_field="QRS_position_"+signal_name;

            % Save QRS positions in the new field
            newData.(mapName).(subjectName).(name_of_field) = QRS_positions;
        end
    end
end

