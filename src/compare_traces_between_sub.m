function compare_traces_between_sub(data, fc, figure_path)
    % COMPARE_TRACES_BETWEEN_SUB Compare and save plots for traces across subjects.
    %
    %   COMPARE_TRACES_BETWEEN_SUB(DATA, FC, FIGURE_PATH) creates comparison plots for
    %   different traces (mean and spectrum) across subjects in the provided dataset.
    %   The plots are saved to the specified path.
    %
    %   Inputs:
    %       DATA - Struct, containing the processed map data organized by map type and index.
    %       FC - Numeric, the cutoff frequency for filtering signals.
    %       FIGURE_PATH - String, the directory path where the plots will be saved.
    
    % Define combinations for plotting mean and spectrum comparisons
    table_pox = [false, true;
                 true, true];
    
    % Define plot types
    type_plots = ["comp_case_by_sign"; "comp_case_spectrum_by_sign"];
    
    % Loop through each plot type combination
    for l = 1:2
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
            subjects = fieldnames(data.(map));
            
            % Loop through each trace type
            for k = ["rov", "ref", "spare1", "spare2", "spare3"]
                
                % Initialize legend entries for each trace type
                legend_entries = cell(1, length(subjects));
                
                % Loop through each subject
                for j = 1:length(subjects)
                    sub = map + num2str(j);
                    trace = k + '_trace';
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), trace:' + k + ', subjects comparison';
                    
                    % Create a new figure
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    hold on
                    
                    % Plot the signal comparisons for the current trace type
                    compare_by_plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l));
                    
                    % Add current subject to legend entries
                    legend_entries{j} = ['Subject ' num2str(j)];
                end
                
                % Add legend to the plot
                legend(legend_entries);
                hold off
                
                % Save the plot
                save_plot(i, '', k, type_plots(l), figure_path + "\traces_comp", fig, true);
            end
        end
    end
end
