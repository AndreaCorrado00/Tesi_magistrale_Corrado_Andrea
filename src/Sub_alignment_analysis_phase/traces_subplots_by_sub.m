function traces_subplots_by_sub(data, fc, figure_path)
    % traces_subplots_by_sub - Generates and saves subplots of different trace types for specific subjects and maps.
    %
    % Syntax: traces_subplots_by_sub(data, fc, figure_path)
    %
    % Inputs:
    %    data - Struct containing the signal data for various subjects and maps.
    %    fc - Sampling frequency of the signals.
    %    figure_path - Directory path where the generated figures will be saved.
    %
    % This function iterates over specific maps ('A', 'B', 'C') and subjects,
    % plotting three types of traces ('rov', 'ref', 'spare2') in subplots.
    % The plots are then saved to the specified directory.

    % Define combinations for plotting mean and spectrum comparisons
    % (Currently unused, but could be for more advanced plotting configurations)
    table_pox = [false, false, true, true;
                 true,  false, true, false;
                 false, true,  false,true;];
    
    % Define plot types (currently only "single_record" is used)
    type_plots = ["single_record"];
    
    % Loop through each plot type combination (only one type currently)
    for l = 1
        % Loop through each map type: 'A', 'B', 'C'
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;  % Construct the map field name
            subjects = fieldnames(data.(map));  % Get list of subjects for this map
            
            % Loop through each subject (currently limited to subject 10)
            for j = 10 %:length(subjects)
                sub = map + num2str(j);  % Construct the subject field name
                traces = fieldnames(data.(string(map)).(string(sub)));  % Get the trace types
                
                % Get the number of columns (N) in the 'rov_trace' field
                [M, N] = size(data.(map).(sub).rov_trace);  
                
                % Loop through each record (column) of the 'rov_trace'
                for h=1:N
                    % Create a new figure, maximized to full screen
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    
                    % Define trace names to be plotted
                    traces_names = ["rov", "ref", "spare2"];
                    
                    % Loop through each trace type and generate subplots
                    for k = 1:3
                        subplot(3,1,k)
                        trace = traces_names(k) + "_trace";  % Construct the trace field name
                        title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + num2str(j) +', ' + traces_names(k) + ' trace, record: ' + num2str(h);
                        signals = table2array(data.(map).(sub).(trace));  % Extract the signal data for the current trace

                        % Plot the signal data
                        x = [0:1/fc:1-1/fc]';  % Time axis based on sampling frequency
                        plot(x, signals(:,h), "LineWidth", 1);  % Plot the signal with specified line width

                        % Set x and y axis limits
                        xlim([0, x(end)]);
                        ylim([min(signals(:,h)) - 0.2 * abs(min(signals(:,h))), max(signals(:,h)) + 0.2 * abs(max(signals(:,h)))]); 

                        % Label the axes
                        xlabel('time [s]')
                        ylabel('Voltage [mV]')

                        % Add title to the subplot
                        title(title_plot)
                    end
                    
                    % Save the plot with a specific filename and type
                    file_name = "MAP_" + i + "_sub_" + num2str(j) + '_record_' + num2str(h) + '_';
                    save_plot(file_name, type_plots(l), figure_path, fig, true);
                end
            end
        end
    end
end
