function TM_dataset=evaluate_TM_1_on_dataset(data,T,fs)

TM_dataset=data;

% 1. Define the template (biphasic)
N = round(T * fs);  % Number of samples in the template


t_template = linspace(0, T, N); 
 

% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = subjects{j};
        rov_signals=data.(map).(sub).rov_trace;

        [~,L]=size(rov_signals);
        TM_signals=nan(size(rov_signals));

        for k=1:L
            signal_example=rov_signals{:,k};
            norm_signal = sqrt(sum(signal_example.^2));
            signal_example=signal_example/norm_signal;
            signal_example=movmean(signal_example,50);
            % amplitude = max(abs(signal_example)); 
            template =  sin(2 * pi * 1/T *t_template); % Biphasic siusoid template
            norm_template = sqrt(sum(template.^2));
            template=template/norm_template;
            corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)
            % Normalization factors
              % Norm of the signal
              % Norm of the template
            % corr = corr / (norm_signal * norm_template);
            TM_signals(:,k)=movmean(corr,50);
            
        end
        TM_dataset.(map).(sub).rov_trace=array2table(TM_signals);
        
    end
end
TM_dataset.T=T;