function compare_case_signals(data, fc, figure_path)
    % COMPARE_CASE_SIGNALS Compare and save plots for different signal types across cases.
    %
    %   COMPARE_CASE_SIGNALS(DATA, FC, FIGURE_PATH) creates comparison plots for different
    %   signal types (mean and spectrum) for each case in the provided dataset. The plots 
    %   are saved to the specified path.
    %
    %   Inputs:
    %       DATA - Struct, containing the processed map data organized by map type and index.
    %       FC - Numeric, the cutoff frequency for filtering signals.
    %       FIGURE_PATH - String, the directory path where the plots will be saved.
    
    % Define combinations for plotting mean and spectrum comparisons

    table_pox = [false, false, true, true;
                 true,  false, true, false;
                 false, true,  false,true;];
    
    % Define plot types
    type_plots = ["comp_mean_confidence_by_case"; "comp_mean_sd_by_case";"comp_mean_conf_spectrum_by_case";"comp_mean_sd_spectrum_by_case"];
    
    % Loop through each plot type combination
    for l = 1:4
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;



            % Create a new figure
            fig = figure(1);
            fig.WindowState = "maximized";
            hold on
            traces_names=["rov", "ref", "spare1","spare2","spare3"];
            % Loop through each trace type and plot comparisons
            for k = 1:5
                subplot(5,1,k)
                trace = traces_names(k) + "_trace";
                title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), population, '+ traces_names(k)+' trace';

                % Plot the signal comparisons
                compare_by_plotting_signals(data.(map).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l), table_pox(3, l));
            end
            hold off

            % Save the plot
            file_name="MAP_"+i+"_population_";
            save_plot(file_name, type_plots(l), figure_path + "\cases_comp", fig, true);

        end
    end
end



