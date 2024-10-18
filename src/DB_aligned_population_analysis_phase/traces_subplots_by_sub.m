function traces_subplots_by_sub(data, fc, figure_path)
    % Function to generate and save subplots for different types of traces
    % for each subject across different maps.
    %
    % INPUTS:
    %   data - Structured data containing trace information for different maps and subjects
    %   fc - Sampling frequency for the traces
    %   figure_path - Directory path where figures will be saved
    %
    % OUTPUT:
    %   None. The function saves figures to the specified directory.

    % Define combinations for plotting mean and spectrum comparisons
    table_pox = [false, false, true, true;
                 true,  false, true, false;
                 false, true,  false,true;];
    
    % Define plot types
    type_plots = ["single_record"];
    
    % Loop through each plot type combination
    for l = 1
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
           


            [~, N] = size(data.(map).rov_trace);
            for h = 1:N
                % Create a new figure
                fig = figure(1);
                fig.WindowState = "maximized";
                traces_names = ["rov", "ref", "spare1", "spare2", "spare3"];

                % Loop through each trace type and plot comparisons
                for k = 1:5
                    subplot(5,1,k)
                    trace = traces_names(k) + "_trace";
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), '+ traces_names(k)+' trace, record: '+num2str(h);
                    signals = data.(map).(trace);

                    % signal=prepare_signal(signals(:,h),'restore');
                    signal=table2array(signals(:,h));
                   
                 
                    % Plot the trace signals
                    x = [0:1/fc:1-1/fc]';

                    plot(x, signal, "LineWidth", 1);
                    xlim([0, x(end)])
                    % ylim([min(signals(:,h)) - 0.2 * abs(min(signals(:,h))), max(signals(:,h)) + 0.2 * abs(max(signals(:,h)))]);
                    xlabel('time [s]')
                    ylabel('Voltage [mV]')
                    title(title_plot)
                end

                % Save the plot
                file_name = "MAP_" + i + '_record_' + num2str(h) + '_';
                save_plot(file_name, type_plots(l), figure_path, fig, true);
            end
        end
    end
end
