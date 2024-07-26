function compare_traces_between_sub_3D_figure(data, fc, figure_path)
    % compare_traces_between_sub_3D_figure generates and saves 3D plots 
    % comparing signal traces between subjects for different map types.
    % Inputs:
    %   data: Struct containing signal data organized by map and subject.
    %   fc: Cutoff frequency for frequency domain analysis.
    %   figure_path: Path to save the generated figures.
    
    % Define combinations for plotting mean and spectrum comparisons
    table_pox = [false, true];
    
    % Define plot types
    type_plots = ["comp_case_by_sign"; "comp_case_spectrum_by_sign"];
    
    % Loop through each plot type combination
    for l = 1:2
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
            subjects = fieldnames(data.(map));
            
            % Loop through each trace type (currently only 'rov')
            for k = ["rov", "ref", "spare1", "spare2", "spare3"]
                
                % Create a new figure for the 3D plot
                fig = figure;
                fig.WindowState = "maximized";
                hold on

                % Set axis labels and title
                xlabel('Subject');
                zlabel('Amplitude');

                % Set the y-axis label and limits based on plot type
                if l == 1
                    ylabel('Time [s]');
                else
                    ylabel('Frequency [Hz]');
                    ylim([0, 200]);
                end

                % Build the title for the plot
                title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), trace:' + k + ', 3D subjects comparison';
                title(title_plot);
                
                % Loop through each subject
                for j = 1:length(subjects)
                    sub = map + num2str(j);
                    trace = k + '_trace';
                    
                    % Get the data to plot
                    signal_data = data.(map).(sub).(trace);
                    
                    % Call the function to get the signals data
                    [y, z_data] = signal_builder_3D_plot(signal_data, fc, table_pox(l));
                    
                    % Define the x position for the current subject
                    x_pos = j;

                    % Plot the data for the current subject
                    % Since z_data includes the mean signal and potentially individual signals,
                    % plot them accordingly
                    for col = 1:size(z_data, 2)
                        plot3(x_pos * ones(size(y)), y, z_data(:, col), 'LineWidth', 1);
                    end
                end
                
                % Adjust view to 3D
                view(3);
                grid on;
                
                hold off;

                % Save the plot
                file_name = "MAP_" + i + "_trace_"+k+'_';
                save_3D_plot(file_name, type_plots(l), figure_path + "\3D_figures", fig, true);
            end
        end
    end
end

