function TM_dataset = evaluate_TM_1_on_dataset(data, T, fs)
    % EVALUATE_TM_1_ON_DATASET Applies template matching (TM) to a dataset of
    % rov_trace signals and returns the dataset with processed signals.
    %
    % This function performs template matching on the rov_trace signals of each 
    % subject in the provided dataset. It utilizes a biphasic template generated 
    % based on the given duration (T) and sampling frequency (fs). The template 
    % is used to compute the cross-correlation of each signal in the dataset, 
    % with the results stored in the TM_dataset.
    %
    % INPUTS:
    %   data     - A struct containing the dataset with rov_trace signals for each subject 
    %              and map types (e.g., MAP_A, MAP_B, MAP_C).
    %   T        - The duration (in seconds) of the template used for matching.
    %   fs       - The sampling frequency of the rov_trace signals.
    %
    % OUTPUT:
    %   TM_dataset - The original dataset with the computed template-matching signals
    %                added to the corresponding fields.
    %
    % EXAMPLE:
    %   TM_dataset = evaluate_TM_1_on_dataset(data, T, fs);
    %   % Returns the dataset with processed rov_trace signals after template matching.

    TM_dataset = data;  % Initialize the output dataset with the input data

    % 1. Define the template (biphasic)
    N = round(T * fs);  % Number of samples in the template
    t_template = linspace(0, T, N);  % Time vector for template

    % Loop through each map type: A, B, C
    for i = ["A", "B", "C"]
        map = 'MAP_' + i;  % Map name (e.g., 'MAP_A')
        subjects = fieldnames(data.(map));  % Get subject names within each map

        % Loop through each subject
        for j = 1:length(subjects)
            sub = subjects{j};  % Current subject
            rov_signals = data.(map).(sub).rov_trace;  % Get the rov_trace signals

            [~, L] = size(rov_signals);  % Number of signals (columns in rov_trace)
            TM_signals = nan(size(rov_signals));  % Initialize TM signals matrix

            for k = 1:L
                signal_example = rov_signals{:, k};  % Extract each signal
                norm_signal = sqrt(sum(signal_example.^2));  % Signal normalization
                signal_example = signal_example / norm_signal;  % Normalize the signal
                signal_example = movmean(signal_example, 50);  % Smooth the signal

                % Generate biphasic template
                template = generate_biphasic_template(fs, T, 5);  % Biphasic template
                norm_template = sqrt(sum(template.^2));  % Template normalization
                template = template / norm_template;  % Normalize the template

                % Compute cross-correlation between the signal and the template
                corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)
                
                % Apply moving average to the correlation for smoothing
                TM_signals(:, k) = movmean(corr, 50);  % Store the result

                
            end

            % Store the template-matched signals in the dataset
            TM_dataset.(map).(sub).rov_trace = array2table(TM_signals);
        end
    end

    % Store the template duration in the dataset for reference
    TM_dataset.T = T;
end
