function env_dataset=evaluate_envelope_on_dataset(data,N,method)

env_dataset=data;

% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = subjects{j};
        rov_signals=data.(map).(sub).rov_trace;

        [~,L]=size(rov_signals);
        env_signals=nan(size(rov_signals));

        for k=1:L
            x=rov_signals{:,k};
            [yupper, ~] = envelope(x,N,method);
            env_signals(:,k)=yupper;
        end
        env_dataset.(map).(sub).rov_trace=array2table(env_signals);


    end
end