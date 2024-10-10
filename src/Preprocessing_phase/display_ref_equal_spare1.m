function display_ref_equal_spare1(data)
disp('Checking subjects with ref==spare1...')
% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    disp('')
    disp(["MAP "+ i])

    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = map + num2str(j);
        ref_trace=table2array(data.(string(map)).(string(sub)).ref_trace);
        spare1_trace=table2array(data.(string(map)).(string(sub)).spare1_trace);
        if sum(ref_trace(:)-spare1_trace(:))==0
            disp(["     Subject "+num2str(j)+" has spare1 = ref"]);
        else
            [M,N]=size(ref_trace);
            for k=1:N
                if sum(ref_trace(:,k)-spare1_trace(:,k))==0
                    disp(["     Subject "+num2str(j)+" has spare1=ref in record "+num2str(k)]);
                end
            end
        end
    end
end
