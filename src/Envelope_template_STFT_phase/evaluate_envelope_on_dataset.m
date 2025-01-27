function env_dataset = evaluate_envelope_on_dataset(data, N, method)
    % EVALUATE_ENVELOPE_ON_DATASET Applies envelope detection to rov_trace signals
    % and returns the dataset with the envelope signals.
    %
    % This function applies an envelope detection algorithm to the rov_trace signals
    % in the provided dataset. The envelope is computed using the specified method 
    % and window size (N). The results are stored in the env_dataset, with each subject 
    % having its corresponding envelope signal.
    %
    % INPUTS:
    %   data   - A struct containing the dataset with rov_trace signals for each subject
    %            and map types (e.g., MAP_A, MAP_B, MAP_C).
    %   N      - The window size (number of samples) used for the envelope computation.
    %   method - The method used for envelope detection (e.g., 'hilbert', 'analytic', etc.).
    %
    % OUTPUT:
    %   env_dataset - The original dataset with the computed envelope signals added
    %                 to the corresponding fields.
    %
    % EXAMPLE:
    %   env_dataset = evaluate_envelope_on_dataset(data, N, method);
    %   % Returns the dataset with the envelope signals for each subject in each map.

    env_dataset = data;  % Initialize the output dataset with the input data

    % Loop through each map type: A, B, C
    for i = ["A", "B", "C"]
        map = 'MAP_' + i;  % Map name (e.g., 'MAP_A')
        subjects = fieldnames(data.(map));  % Get subject names within each map

        % Loop through each subject
        for j = 1:length(subjects)
            sub = subjects{j};  % Current subject
            rov_signals = data.(map).(sub).rov_trace;  % Get the rov_trace signals

            [~, L] = size(rov_signals);  % Number of signals (columns in rov_trace)
            env_signals = nan(size(rov_signals));  % Initialize env signals matrix

            for k = 1:L
                x = rov_signals{:, k};  % Extract each signal
                [yupper, ~] = envelope(x, N, method);  % Compute the envelope
                env_signals(:, k) = yupper;  % Store the envelope result
            end

            % Store the envelope signals in the dataset
            env_dataset.(map).(sub).rov_trace = array2table(env_signals);
        end
    end
end
