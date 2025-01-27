% This function identifies subjects with identical traces in a structured dataset.
% It compares the 'ref_trace' and 'spare1_trace' of each subject with those of all
% subsequent subjects for each map type (MAP_A, MAP_B, MAP_C). If identical traces
% are found, it reports the pairs of subjects with matching data.
% Inputs:
%   data - A structured data input containing maps and traces for each subject.
% Outputs:
%   Displays messages to the console indicating pairs of subjects with
%   identical 'ref_trace' and 'spare1_trace'. If no repetitions are found,
%   a message stating "There's no repetition" is displayed.

function display_subjects_repeated(data)
    disp('Checking doubled subjects...')

    % Loop through each map type: A, B, C
    for i = ["A", "B", "C"]
        output_string = "";  
        disp('')
        disp(["MAP " + i])
        
        map = 'MAP_' + i;
        subjects = fieldnames(data.(map));

        % Loop through each subject
        for j = 1:length(subjects)
            sub_j = map + num2str(j);
            ref_trace_j = table2array(data.(string(map)).(string(sub_j)).ref_trace);
            spare1_trace_j = table2array(data.(string(map)).(string(sub_j)).spare1_trace);
            
            % Loop through subsequent subjects to compare traces
            for k = j+1:length(subjects)
                sub_k = map + num2str(k);
                ref_trace_k = table2array(data.(string(map)).(string(sub_k)).ref_trace);
                spare1_trace_k = table2array(data.(string(map)).(string(sub_k)).spare1_trace);
                
                % Compare ref_trace and spare1_trace for the two subjects
                if isequal(ref_trace_j, ref_trace_k) && isequal(spare1_trace_j, spare1_trace_k)
                    % Add to the output string the subjects with identical traces
                    output_string = output_string + "sub " + num2str(j) + " == sub " + num2str(k) + newline;
                end
            end
        end
        
        if isempty(output_string)
            disp("  There's no repetition");
        else
            disp("  " + o
