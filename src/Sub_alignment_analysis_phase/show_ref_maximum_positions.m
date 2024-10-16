function show_ref_maximum_positions(data, Fc)

    % Define MAP names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};

    % Number of subjects (assumed to be 12)
    numSubjects = 12;

    % Initialize figures
    % figure1 = figure('Name', 'Max positions per subject', 'WindowState', 'maximized');
    figure2 = figure('Name', 'Boxplot of max positions for all subjects', 'WindowState', 'maximized');

    % Collect all peak positions for all subjects for the second plot
    all_peaks_pos_ref = [];

    % Loop through each map (e.g., MAP_A, MAP_B, MAP_C)
    for i = 1:length(mapNames)
        mapName = 'MAP_' + string(mapNames{i});  % Construct the map name

        % Loop through each subject within the current map
        for j = 1:numSubjects
            subjectName = sprintf('%s%d', mapName, j);  % Construct the subject name

            % Extract the reference signal for the current subject (assuming it's a table)
            subject_trace = data.(mapName).(subjectName).ref_trace;

            % Initialize a vector to hold maximum positions for each signal
            max_positions = zeros(size(subject_trace, 2), 1);  % One entry for each signal (column)

            % Loop through each column in the reference trace
            for col = 1:size(subject_trace, 2)
                % Extract the signal column
                signal = subject_trace{:, col};

                % Define the sampling indices corresponding to 0.2 to 0.8 seconds
                start_index = round(0.2 * Fc) + 1;  % +1 because MATLAB indexing starts at 1
                end_index = round(0.8 * Fc);  % No +1 because we want to include this index

                % Restrict the signal to the time interval [0.2, 0.8] seconds
                restricted_signal = signal(start_index:end_index);

                % Find the maximum absolute value and its position in the restricted signal
                [~, local_max_pos] = max(abs(restricted_signal));  % Index of max in restricted signal
                
                % Calculate the absolute position in the original signal
                max_positions(col) = (local_max_pos + start_index - 1) / Fc;  % Normalize by Fc
            end

            % Append the positions for all signals to the list for the second figure
            all_peaks_pos_ref = [all_peaks_pos_ref; max_positions];

            % % Plot for the current subject in figure 1
            % figure(figure1);
            % subplot(length(mapNames), numSubjects, (i-1)*numSubjects + j);
            % boxplot(max_positions);
            % title(sprintf('Subject %s', subjectName));
            % xlabel('Signal');
            % ylabel('Max Position (normalized)');
            % set(gca, 'XTickLabel', arrayfun(@(x) sprintf('Signal %d', x), 1:size(subject_trace, 2), 'UniformOutput', false));
        end
    end

    % Plot the combined boxplot for all subjects in figure 2
    figure(figure2);
    boxplot(all_peaks_pos_ref);
    title('Boxplot of maximum peak position of reference traces for all subjects and maps');
    xlabel('All Signals');
    ylabel('Time position of maximum peak');
    ylim([0,1])

end
