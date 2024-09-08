function newData = single_sub_alignment(data, Fc, window, strategy, tollerance, plot_alignment)
    % single_sub_alignment - Aligns signals based on QRS positions using reference signals.
    %
    % Syntax: newData = single_sub_alignment(data, Fc, window, strategy, tollerance, plot_alignment)
    %
    % Inputs:
    %    data - Struct containing the signal data for various subjects and maps.
    %    Fc - Sampling frequency of the signals (Hz).
    %    window - Time window (in seconds) used to define the alignment range.
    %    strategy - Alignment strategy ('only_ref' or 'ref_and_spare2').
    %    tollerance - Tolerance (in seconds) used for aligning signals in the 'ref_and_spare2' strategy.
    %    plot_alignment - Boolean flag to enable or disable plotting of the alignment process.
    %
    % Output:
    %    newData - Struct containing the aligned signals and updated QRS positions.
    %
    % This function iterates over maps ('MAP_A', 'MAP_B', 'MAP_C') and subjects, aligning signals 
    % in the 'rov_trace' field based on QRS positions from reference signals. The alignment is done 
    % using either the 'only_ref' strategy, which aligns to a single reference trace, or the 
    % 'ref_and_spare2' strategy, which also considers a secondary reference trace ('spare2').
    % The results are saved back into the structure as new aligned traces.

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
            
            % Extract the rov and reference signals from the data structure
            rovSignals = newData.(mapName).(subjectName).rov_trace;
            refSignals = newData.(mapName).(subjectName).ref_trace;
            
            % Loop through each signal (column) in the rovSignals table
            for k = 1:width(rovSignals)
                signal = rovSignals{:, k};  % Extract the k-th signal from the rov trace
                half_width = round((Fc * window) / 2);  % Calculate half of the alignment window in samples
                ref = refSignals{:, k};  % Extract the corresponding reference signal
                

                
                % Switch based on the selected alignment strategy
                switch strategy
                    case 'only_ref'
                        % Retrieve and impute missing QRS positions for the reference trace
                        QRSpositions_ref = newData.(mapName).(subjectName).QRS_position_ref_trace;
                        QRSpositions_ref = impute_QRS_pos(QRSpositions_ref);
                        % Align the rov signal to the reference QRS positions
                        QRS_pos = QRSpositions_ref{:, k};
                        rovSignals{:, k} = align_to_QRS_ref(signal, QRS_pos, half_width, ref, plot_alignment);
                        
                    case 'ref_and_spare2'
                        % Retrieve and impute missing QRS positions for the reference trace
                        QRSpositions_ref = newData.(mapName).(subjectName).QRS_position_ref_trace;
                        QRSpositions_ref = impute_QRS_pos(QRSpositions_ref);
                        % Align using both reference and spare2 QRS positions
                        tollerance = tollerance * Fc;  % Convert tolerance from seconds to samples
                        
                        % Retrieve and impute missing QRS positions for the spare2 trace
                        QRSpositions_spare2 = newData.(mapName).(subjectName).QRS_position_spare2_trace;
                        QRSpositions_spare2 = impute_QRS_pos(QRSpositions_spare2);
                        
                        % Align the rov signal considering both reference and spare2 QRS positions
                        QRS_ref = QRSpositions_ref{:, k};
                        QRS_spare2 = QRSpositions_spare2{:, k};
                        rovSignals{:, k} = align_to_QRS_ref_and_spare(signal, QRS_ref, QRS_spare2, half_width, ref, tollerance, plot_alignment);
                    case 'ref_and_spare1'
                        % Retrieve and impute missing QRS positions for the reference trace
                        QRSpositions_ref = newData.(mapName).(subjectName).QRS_position_ref_trace;
                        QRSpositions_ref = impute_QRS_pos(QRSpositions_ref);
                        % Retrieve and impute missing QRS positions for the reference trace
                        QRSpositions_spare1 = newData.(mapName).(subjectName).QRS_position_spare1_trace;
                        QRSpositions_spare1 = impute_QRS_pos(QRSpositions_spare1);
                        % Align using both spare 1 and spare2 QRS positions
                        tollerance = tollerance * Fc;  % Convert tolerance from seconds to samples
                        
                         % Retrieve and impute missing QRS positions for the spare2 trace
                        QRSpositions_spare2 = newData.(mapName).(subjectName).QRS_position_spare2_trace;
                        QRSpositions_spare2 = impute_QRS_pos(QRSpositions_spare2);
                        
                        % Align the rov signal considering both reference and spare2 QRS positions
                        QRS_spare2 = QRSpositions_spare2{:, k};
                        QRS_spare1= QRSpositions_spare1{:, k};
                        rovSignals{:, k} = align_to_QRS_ref_and_spare(signal, QRS_spare1, QRS_spare2, half_width, ref, tollerance, plot_alignment);
                end
            end

            % Save the aligned rov signals back into the data structure
            newData.(mapName).(subjectName).rov_trace = rovSignals;
            
            % Save the updated QRS positions based on the strategy used
            switch strategy
                case 'only_ref'
                    newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
                case 'ref_and_spare2'
                    newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
                    newData.(mapName).(subjectName).QRS_position_spare2_trace = QRSpositions_spare2;
                case 'ref_and_spare1'
                    newData.(mapName).(subjectName).QRS_position_ref_trace = QRSpositions_ref;
                    newData.(mapName).(subjectName).QRS_position_spare2_trace = QRSpositions_spare2;
                    newData.(mapName).(subjectName).QRS_position_spare1_trace = QRSpositions_spare1;
            end
        end
    end
end
