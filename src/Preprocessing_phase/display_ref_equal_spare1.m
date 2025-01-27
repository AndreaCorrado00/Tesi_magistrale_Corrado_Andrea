% This function analyzes subject data stored in a structured format.
% It checks if the 'spare1_trace' is identical to the 'ref_trace' for each subject
% in three different maps (MAP_A, MAP_B, MAP_C). If the traces are identical,
% it reports the subject and, if applicable, the specific record where equality is found.
% Inputs:
%   data - A structured data input containing maps and traces for each subject.
% Outputs:
%   Displays messages to the console indicating which subjects or records
%   have 'spare1_trace' equal to 'ref_trace'.

function display_ref_equal_spare1(data)
    disp('Checking subjects with ref==spare1...')
    % Loop through each map type: A, B, C
    for i = ["A", "B", "C"]
        disp('')
        disp(["MAP " + i])

        map = 'MAP_' + i;
        subjects = fieldnames(data.(map));

        % Loop through each subject
        for j = 1:length(subjects)
            sub = map + num2str(j);
            ref_trace = table2array(data.(string(map)).(string(sub)).ref_trace);
            spare1_trace = table2array(data.(string(map)).(string(sub)).spare1_trace);
            if sum(ref_trace(:) - spare1_trace(:)) == 0
                disp(["     Subject " + num2str(j) + " has spare1 = ref"]);
            else
                [M, N] = size(ref_trace);
                for k = 1:N
                    if sum(ref_trace(:, k) - spare1_trace(:, k)) == 0
                        disp(["     Subject " + num2str(j) + " has spare1=ref in record " + num2str(k)]);
                    end
                end
            end
        end
    end
end
