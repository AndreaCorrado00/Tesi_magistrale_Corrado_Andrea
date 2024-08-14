function plotting_signals(data, figure_path, plot_type, saving, check_noise)
    % This function generates and saves various types of plots for the given data.
    % The function can create different plot types based on the specified 'plot_type'
    % and save the figures if 'saving' is true. It also includes an option to check
    % for noise by zooming in on a specific frequency range.
    %
    % Inputs:
    %   data        - The structured dataset containing signal records for each subject.
    %   figure_path - Path where the figures will be saved if 'saving' is true.
    %   plot_type   - A string specifying the type of plot to generate.
    %   saving      - Boolean flag to determine whether to save the plots.
    %   check_noise - Boolean flag to determine whether to check for noise by zooming in.
    
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
    subjects = fieldnames(data);
    for i = 1:length(subjects)
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
        
        % If checking for noise, adjust the x-axis limit and update the title
        if check_noise
            xlim([40, fc/2]);
            title(title_plot + ", noise check");
            plot_type = plot_types(ind_plot) + "_noise_check";
        end
        
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

