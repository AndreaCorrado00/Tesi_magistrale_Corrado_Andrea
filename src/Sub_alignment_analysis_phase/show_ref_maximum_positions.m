function show_ref_maximum_positions(data, Fc)
    % This function analyzes the maximum peak positions in the reference traces
    % for all subjects across three maps (MAP_A, MAP_B, MAP_C).
    % It plots a boxplot of maximum peak positions for all signals in the reference traces.
    %
    % Parameters:
    %   data (struct): The dataset containing reference traces for multiple subjects.
    %   Fc (scalar): The sampling frequency (in Hz).

    % Define map names (MAP_A, MAP_B, MAP_C)
    mapNames = {'A', 'B', 'C'};

    % Number of subjects (assumed to be 12)
    numSubjects = 12;

    % Initialize figure for boxplot (for all subjects combined)
    figure2 = figure('Name', 'Boxplot of max positions for all subjects');

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

            % Initialize a vector to hold maximum positions for each signal (column)
            max_positions = zeros(size(subject_trace, 2), 1);  

            % Loop through each signal (column) in the reference trace
            for col = 1:size(subject_trace, 2)
                % Extract the signal column
                signal = subject_trace{:, col};

                % Define the sampling indices corresponding to the time interval [0.2, 0.8] seconds
                start_index = round(0.2 * Fc) + 1;  % +1 for 1-based indexing
                end_index = round(0.8 * Fc);        % Inclusive of the end index

                % Restrict the signal to the time interval [0.2, 0.8] seconds
                restricted_signal = signal(start_index:end_index);

                % Find the maximum absolute value and its position in the restricted signal
                [~, local_max_pos] = max(abs(restricted_signal));  % Index of max in restricted signal
                
                % Calculate the absolute position in the original signal (normalized by Fc)
                max_positions(col) = (local_max_pos + start_index - 1) / Fc;
            end

            % Append the positions for all signals of the current subject to the list
            all_peaks_pos_ref = [all_peaks_pos_ref; max_positions];

            % Optionally, plot for the current subject in figure1 (if required)
            % figure(figure1);
            % subplot(length(mapNames), numSubjects, (i-1)*numSubjects + j);
            % boxplot(max_positions);
            % title(sprintf('Subject %s', subjectName));
            % xlabel('Signal');
            % ylabel('Max Position (normalized)');
            % set(gca, 'XTickLabel', arrayfun(@(x) sprintf('Signal %d', x), 1:size(subject_trace, 2), 'UniformOutput', false));
        end
    end

    % Plot the combined boxplot for all subjects in figure2
    figure(figure2);
    boxplot(all_peaks_pos_ref);
    title('Boxplot of maximum peak positions of reference traces for all subjects and maps');
    xlabel('All Signals');
    ylabel('Time position of maximum peak');
    ylim([0.46, 0.56]);  % Limit the y-axis to the expected range
end
