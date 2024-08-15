function newData=single_sub_alignment(data,Fc,window, strategy,tollerance,plot_alignment)
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
            % Extract the rov signals (assumed to be a table)
            rovSignals = newData.(mapName).(subjectName).rov_trace;            
            refSignals=newData.(mapName).(subjectName).ref_trace;
            
            % Loop through each signal in the reference table
            for k = 1:width(rovSignals)
                signal = rovSignals{:, k};
                half_width=round((Fc*window)/2);
                ref=refSignals{:,k};
                QRSpositions_ref=newData.(mapName).(subjectName).QRS_position_ref_trace;
                QRSpositions_ref=impute_QRS_pos(QRSpositions_ref);
                
                switch strategy
                    case 'only_ref'
                        QRS_pos=QRSpositions_ref{:,k};
                        rovSignals{:, k}=align_to_QRS_ref(signal,QRS_pos,half_width,ref,plot_alignment);
                    case 'ref_and_spare2'
                        tollerance=tollerance*Fc;
                        QRSpositions_spare2=newData.(mapName).(subjectName).QRS_position_spare2_trace;
                        QRSpositions_spare2=impute_QRS_pos(QRSpositions_spare2);
                        QRS_ref=QRSpositions_ref{:,k};
                        QRS_spare2=QRSpositions_spare2{:,k};
                        rovSignals{:, k}=align_to_QRS_ref_and_spare2(signal,QRS_ref,QRS_spare2,half_width,ref,tollerance,plot_alignment);
                end
                    
            end

            % Save QRS positions in the new field
            newData.(mapName).(subjectName).rov_trace = rovSignals;
            switch strategy
                case 'only_ref'
                    newData.(mapName).(subjectName).QRS_positions_ref = QRSpositions_ref;
                case 'ref_and_spare2'
                    newData.(mapName).(subjectName).QRS_positions_ref = QRSpositions_ref;
                    newData.(mapName).(subjectName).QRS_positions_spare = QRSpositions_spare2;
            end
            

        end
    end
end
