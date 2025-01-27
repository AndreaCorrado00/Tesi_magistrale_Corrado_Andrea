function traces_subplots_by_sub(data, fc, figure_path)
% This function creates subplots for each subject's traces and saves the figures.
% It generates time-series plots for different traces (rov, ref, spare1, spare2, spare3)
% for each record of each subject in the dataset.

% Parameters:
%   data (struct): The input dataset containing multiple maps (e.g., MAP_A, MAP_B, MAP_C),
%                  where each subject's data contains various traces.
%   fc (numeric): The sampling frequency to calculate the time axis.
%   figure_path (string): The path where the figures will be saved.

    % Define plot types (currently supports single record plots)
    type_plots = ["single_record"];
    
    % Loop through each map type (A, B, C)
    for i = ["A", "B", "C"]
        map = 'MAP_' + i;  % The map name (e.g., 'MAP_A')
        subjects = fieldnames(data.(map));  % List of subjects for the current map

        % Loop through each subject
        for j = 1:length(subjects)
            sub = subjects{j};  % Subject name

            % Get the number of records in the 'rov_trace' field
            [~, N] = size(data.(map).(sub).rov_trace);
            
            % Loop through each record (column) of 'rov_trace'
            for h = 1:N
                % Create a new figure for each record
                fig = figure(1);
                fig.WindowState = "maximized";  % Maximize the figure window
                traces_names = ["rov", "ref", "spare1", "spare2", "spare3"];  % Trace types

                % Loop through each trace type and plot them
                for k = 1:5
                    sub_num = split(sub, '_');  % Extract the subject number
                    sub_num = split(sub_num{2}, i);
                    sub_num = sub_num{end};  % Get the subject number without map type
                    
                    % Create subplot for each trace
                    subplot(5, 1, k)
                    trace = traces_names(k) + "_trace";  % Get trace name
                    title_plot = sprintf('MAP: %s (%s), sub: %s, %s trace, record: %d', ...
                                         i, get_name_of_map(i), sub_num, traces_names(k), h);
                    signals = table2array(data.(map).(sub).(trace));  % Extract trace data

                    % Create time vector based on sampling frequency
                    x = (0:1/fc:1-1/fc)';

                    % Plot the signals
                    plot(x, signals(:, h), "LineWidth", 1);

                    % Adjust plot limits
                    xlim([0, x(end)])
                    ylim([min(signals(:, h)) - 0.2 * abs(min(signals(:, h))), ...
                          max(signals(:, h)) + 0.2 * abs(max(signals(:, h)))]);

                    % Label axes and title
                    xlabel('time [s]')
                    ylabel('Voltage [mV]')
                    title(title_plot)
                end

                % Save the plot as a figure
                file_name = sprintf("MAP_%s_sub_%s_record_%d_", i, sub_num, h);
                save_plot(file_name, type_plots(1), figure_path, fig, true);  % Save the plot to file
            end
        end
    end
end
