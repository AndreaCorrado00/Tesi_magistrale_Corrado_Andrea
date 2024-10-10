function display_subjects_repeated(data)
disp('Checking doubled subjects...')

% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    output_string = "";  
    disp('')
    disp(["MAP "+ i])
    
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
            
            % Confronto ref_trace e spare1_trace per i due soggetti
            if isequal(ref_trace_j, ref_trace_k) && isequal(spare1_trace_j, spare1_trace_k)
                % Aggiungi alla stringa di output i soggetti che hanno tracce uguali
                output_string = output_string + "sub " + num2str(j) + " == sub " + num2str(k) + newline;
            end
        end
    end
    if isempty(output_string)
        disp("  There's no repetition");
    else
        disp("  "+output_string);
    end
end




end
