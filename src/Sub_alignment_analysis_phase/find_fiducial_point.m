function newData = find_fiducial_point(data, Fc, window)

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

        trace_align=decide_strategy(newData.(mapName).(subjectName).traces_origin);

        % Extract the rov and reference signals from the data structure
        rovSignals = newData.(mapName).(subjectName).rov_trace;
        alignSignals = newData.(mapName).(subjectName).(trace_align);
        FP_positions={};
        QRS_positions={};

        % Loop through each signal (column) in the rovSignals table
        for k = 1:width(rovSignals)
            signal = rovSignals{:, k};  % Extract the k-th signal from the rov trace
            half_width = round((Fc * window) / 2);  % Calculate half of the alignment window in samples
            alignSignal = alignSignals{:, k};  % Extract the corresponding reference signal
            QRS_pos=find(abs(alignSignal)==max(abs(alignSignal)),1);


            % alignement and fiducial point
            [FP_pos,new_rov] = align_to_QRS(signal, QRS_pos, half_width);
            % saving rov trace
            rovSignals{:, k}=new_rov;
            % saving FP position
            FP_positions{k}=FP_pos;
            QRS_positions{k}=QRS_pos;
            % 
            % switch trace_align
            %     case "ref_trace"
            % 
            %     case "spare_trace"
            % 
            % end
        end

        % Save the aligned rov signals back into the data structure
            newData.(mapName).(subjectName).rov_trace = rovSignals;
            newData.(mapName).(subjectName).FP_position_rov = FP_positions;

            % Saving QRS position informations
            QRS_pos_fiel_name="QRS_position_"+trace_align;
            newData.(mapName).(subjectName).(QRS_pos_fiel_name)=QRS_positions;
            newData.(mapName).(subjectName).alignment_trace=trace_align;
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
