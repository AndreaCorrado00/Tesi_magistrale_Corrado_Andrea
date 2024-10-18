function show_DB_reduction(data)

% Define MAP names (MAP_A, MAP_B, MAP_C)
mapNames = {'A', 'B', 'C'};

% Number of subjects (assumed to be 12)
numSubjects = 12;

%% Building a subset of the DB: subjets for whom reference traces are ECG
refECG_data=struct;
% Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
MAPs_cardinalities_original=[0,0,0]; % MAP_A ,B, C
for i = 1:length(mapNames)
    mapName = 'MAP_' + string(mapNames{i});  % Construct the map name

    % Loop through each subject within the current map
    for j = 1:numSubjects
        subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name
        guide_trace=decide_strategy(data.(mapName).(subjectName).traces_origin);

        if j ~= 5 
            [~,M]=size(data.(mapName).(subjectName).rov_trace);
            MAPs_cardinalities_original(i)=MAPs_cardinalities_original(i)+M;
        end

        if guide_trace=="ref_trace"
            refECG_data.(mapName).(subjectName)=data.(mapName).(subjectName);
        end

    end
end



%% Statistics of database reduction
n_sub_red=length(fieldnames(refECG_data.MAP_A));

% Number of remaining subs
clc;

fprintf("Remaining subjects are: "+num2str(n_sub_red)+" with n signals: \n")


% remaining signals cardinality
MAPs_cardinalities_reduced=[0,0,0]; % MAP_A ,B, C

for i = 1:length(mapNames)
    mapName = 'MAP_' + string(mapNames{i});  % Construct the map name
    subjects=fieldnames(refECG_data.(mapName));

    % Loop through each subject within the current map
    for j = 1:length(subjects)
        subjectName = subjects{j};  % Construct the subject name

        % Checking presence of the repeated subject 5
        sub_idx = strsplit(subjectName, "_");  
        sub_idx = string(sub_idx(2));          
        last_char = sub_idx{1}(end);

        if str2double(last_char) ~= 5 
            [~,M]=size(refECG_data.(mapName).(subjectName).rov_trace);
            MAPs_cardinalities_reduced(i)=MAPs_cardinalities_reduced(i)+M;
        end

    end
end

fprintf("   MAP_A: "+num2str(MAPs_cardinalities_reduced(1))+" from "+num2str(MAPs_cardinalities_original(1))+"\n")
fprintf("   MAP_B: "+num2str(MAPs_cardinalities_reduced(2))+" from "+num2str(MAPs_cardinalities_original(2))+"\n")
fprintf("   MAP_C: "+num2str(MAPs_cardinalities_reduced(3))+" from "+num2str(MAPs_cardinalities_original(3))+"\n")

