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
    table_pox = [false, true;
                 true, true];
    
    % Define plot types
    type_plots = ["comp_sig_mean_by_case"; "comp_sig_spectrum_by_case"];
    
    % Loop through each plot type combination
    for l = 1:2
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
            subjects = fieldnames(data.(map));
            
            % Loop through each subject
            for j = 1:length(subjects)
                sub = map + num2str(j);
                traces = fieldnames(data.(string(map)).(string(sub)));
                
                % Create a new figure
                fig = figure(1);
                fig.WindowState = "maximized";
                hold on
                
                % Loop through each trace type and plot comparisons
                for k = ["rov", "ref", "spare1", "spare2", "spare3"]
                    trace = k + '_trace';
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + num2str(j) + ', traces comparison';
                    
                    % Plot the signal comparisons
                    compare_by_plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l));
                end
                
                % Add legend to the plot
                legend('ROV', 'REF', 'SPARE 1', 'SPARE 2', 'SPARE 3');
                hold off
                
                % Save the plot
                save_plot(i, j, '', type_plots(l), figure_path + "\cases_comp", fig, true);
            end
        end
    end
end
