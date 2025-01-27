% This function generates and saves subplots of traces for each subject and record
% in the given dataset. The function loops through the maps (A, B, C), subjects, and 
% trace types, plotting the signals for each record in a maximized figure. Each subplot
% corresponds to a specific trace type, and the figures are saved with descriptive filenames.
% 
% Inputs:
%   data         - A structured dataset containing signal data for maps, subjects, and traces.
%   fc           - Sampling frequency of the signals, used to calculate the time axis.
%   figure_path  - Path where the generated figures will be saved.
% Outputs:
%   Figures are saved as files in the specified directory. The function does not return values.
%
% Additional Details:
% - Traces considered: 'rov trace', 'ref trace', 'spare1 trace', 'spare2 trace', 'spare3 trace'.
% - Each record for a subject is plotted, and the subplots are labeled accordingly.
% - Figures are saved in a directory structure based on the plot type.
% - The plotting function uses a standardized time axis and voltage scaling.

function traces_subplots_by_sub(data, fc, figure_path)
    
    % Define combinations for plotting mean and spectrum comparisons
    table_pox = [false, false, true, true;
                 true,  false, true, false;
                 false, true,  false, true;];
    
    % Define plot types
    type_plots = ["single_record"];
    
    % Loop through each plot type combination
    for l = 1
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
            subjects = fieldnames(data.(map));
            
            % Loop through each subject
            for j = 1:length(subjects)
                sub = map + num2str(j);
                traces = fieldnames(data.(string(map)).(string(sub)));
                
                [M, N] = size(data.(map).(sub).rov_trace); % Determine the number of records
                for h = 1:N
                    % Create a new figure
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    traces_names = ["rov", "ref", "spare1", "spare2", "spare3"];
                    
                    % Loop through each trace type and plot comparisons
                    for k = 1:5
                        subplot(5, 1, k)
                        trace = traces_names(k) + "_trace";
                        title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + num2str(j) + ', ' + traces_names(k) + ' trace, record: ' + num2str(h);
                        signals = table2array(data.(map).(sub).(trace));
                        
                        % Plot the signal
                        x = [0:1/fc:1-1/fc]';
                        plot(x, signals(:, h), "LineWidth", 1);

                        xlim([0, x(end)])
                        ylim([min(signals(:, h)) - 0.2 * abs(min(signals(:, h))), max(signals(:, h)) + 0.2 * abs(max(signals(:, h)))]); 

                        xlabel('time [s]')
                        ylabel('Voltage [mV]')
                        title(title_plot)
                    end
                    
                    % Save the plot
                    file_name = "MAP_" + i + "_sub_" + num2str(j) + '_record_' + num2str(h) + '_';
                    save_plot(file_name, type_plots(l), figure_path + "\whole_single_records", fig, true);
                end
            end
        end
    end
end
