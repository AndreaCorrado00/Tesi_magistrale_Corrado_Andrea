function compare_maps_between_signals(data, fc, figure_path)
    % COMPARE_MAPS_BETWEEN_SIGNALS Compare and save plots for different maps across signals.
    %
    %   COMPARE_MAPS_BETWEEN_SIGNALS(DATA, FC, FIGURE_PATH) creates comparison plots for
    %   different maps (mean and spectrum) across signals in the provided dataset.
    %   The plots are saved to the specified path.
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
    type_plots = ["comp_mean_confidence_by_map"; "comp_mean_sd_by_map";"comp_mean_conf_spectrum_by_map";"comp_mean_sd_spectrum_by_map"];
    
    % Define map types
    maps = ["A", "B", "C"];
    
    % Loop through each plot type combination
    for l = 1:4
        % Loop through each trace type
        for k = ["rov", "ref", "spare1", "spare2", "spare3"]


            % Initialize legend entries for the current trace type
            legend_entries = cell(1, length(maps));

            % Loop through each map type
            for i = 1:3
                map = 'MAP_' + maps(i);

                trace = k + '_trace';

                title_plot = 'Trace:' + k + ', population' +', MAP comparison';

                % Create a new figure
                fig = figure(1);
                fig.WindowState = "maximized";
                hold on

                % Plot the signal comparisons for the current map
                compare_by_plotting_signals(data.(map).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l), table_pox(3, l));

                % Add current map to legend entries
                legend_entries{i} = ['MAP ' + maps(i)];
            end

            % Add legend to the plot
            legend(legend_entries);
            hold off

            % Save the plot
            file_name="trace_"+k+"_";
            save_plot(file_name, type_plots(l), figure_path + "\map_comp", fig, true);

        end
    end
end



