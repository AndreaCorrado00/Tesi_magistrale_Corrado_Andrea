function plotting_PhysioNet_signals(signals, labels, figure_path, plot_type, saving)

    % Define available plot types and corresponding titles
    plot_types = ["time_mean_spaghetti", "time_mean_conf", "time_mean_sd", ...
                  "freq_mean_spaghetti", "freq_mean_conf", "freq_mean_sd"];
    titles = ["Spaghetti plot ", "Mean and confidence intervals 95% ", ...
              "Mean and +/- sd ", "Spectrum spaghetti plot ", ...
              "Spectrum mean and confidence intervals 95% ", "Spectrum mean and +/- sd "];
    
    % Find the index of the specified plot type
    ind_plot = find(plot_type == plot_types);

    % Define table for plot options (mean, confidence intervals, standard deviation)
    table_pox = [false, false, false; 
                 false, true, false; 
                 false, false, true; 
                 true, false, false; 
                 true, true, false; 
                 true, false, true];
    
    % Iterate over each subject in the dataset
    for i = 1:length(signals)
        % Extract records and sampling frequency for the current subject
        records = data.(subjects{i}).records_table;
        fc = data.(subjects{i}).fc;
        
        % Create a new figure window
        fig = figure(1);
        fig.WindowState = "maximized";
        
        % Define the title for the plot
        title_plot = titles(ind_plot) + "for Sub: " + num2str(i);
        
        % Build and display the plot based on the specified type
        build_plot(records, title_plot, fc, table_pox(ind_plot, 1), ...
                   table_pox(ind_plot, 2), table_pox(ind_plot, 3));
        
        
        % Get the current figure
        fig = gcf;
        
        % Save the plot if 'saving' is true
        if saving
            file_name = plot_types(ind_plot) + "Sub_" + num2str(i) + "MIT_dataset_eval";
            save_plot(file_name, plot_type, fullfile(figure_path, "data_visual"), fig, true);
        else
            % Pause to allow viewing and then close the figure if not saving
            pause(3);
            close(fig);
        end
    end
end