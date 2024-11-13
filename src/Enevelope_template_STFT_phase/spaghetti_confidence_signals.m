function spaghetti_confidence_signals(data, fc, figure_path,what_is_plotted)
    % SPAGHETTI_CONFIDENCE_SIGNALS Generate and save plots for multiple signal types.
    %
    %   SPAGHETTI_CONFIDENCE_SIGNALS(DATA, FC, FIGURE_PATH) creates spaghetti and confidence
    %   plots for both time and frequency domains for each signal in the provided dataset.
    %   The plots are saved to the specified path.
    %
    %   Inputs:
    %       DATA - Struct, containing the processed map data organized by map type and index.
    %       FC - Numeric, the cutoff frequency for filtering signals.
    %       FIGURE_PATH - String, the directory path where the plots will be saved.
    
    % Define combinations of plot types
    table_pox = [false, false,false;
                 false, true,false;
                 false, false, true;
                 true, false, false;
                 true, true, false;
                 true, false, true];
    
    % Define plot types
    type_plots = ["spaghetti"; "confidence";"mean_sd"; "spaghetti_freq"; "confidence_freq";"mean_sd_freq"];
    
    % Loop through each plot type combination
    for l = 1:1
        % Loop through each map type: A, B, C
        for i = ["A", "B", "C"]
            map = 'MAP_' + i;
            subjects = fieldnames(data.(map));
            
            % Loop through each subject
            for j = 1:length(subjects)
                sub = subjects{j};
                traces = fieldnames(data.(string(map)).(string(sub)));
                
                % Loop through each trace type
                for k = ["rov"]
                    trace = k + '_trace';
                    sub_num=split(sub,'_');
                    sub_num=split(sub_num{2},i);
                    sub_num=sub_num{end};

                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + ') sub:'+sub_num+ ', trace: ' + k;
                    
                    % Create a new figure
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    
                    % Plot the signals
                    plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(l, 1), table_pox(l, 2), table_pox(l,3),what_is_plotted);
                    
                    % Get the current figure
                    fig = gcf;
                    
                    % Save the plot
                   
                    file_name="MAP_"+i+"_sub_"+sub_num+"_trace_"+k+"_";
                    save_plot(file_name, type_plots(l), figure_path + "\data_visual", fig, true);
                end
            end
        end
    end
end
