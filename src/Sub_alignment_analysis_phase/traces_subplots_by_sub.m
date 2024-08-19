function traces_subplots_by_sub(data, fc, figure_path)
    
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
            subjects = fieldnames(data.(map));
            
            % Loop through each subject
            for j = 10 %:length(subjects)
                sub = map + num2str(j);
                traces = fieldnames(data.(string(map)).(string(sub)));
                
                
                [M, N] = size(data.(map).(sub).rov_trace);
                for h=1:N
                    % Create a new figure
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    traces_names=["rov", "ref", "spare2"];
                    % Loop through each trace type and plot comparisons
                    for k = 1:3
                        subplot(3,1,k)
                        trace = traces_names(k) + "_trace";
                        title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + num2str(j) +', '+ traces_names(k)+' trace, record: '+num2str(h);
                        signals=table2array(data.(map).(sub).(trace));
                        %compare_by_plotting_signals(signals(:,h), title_plot, fc, table_pox(1, l), table_pox(2, l), table_pox(3, l));
                        x = [0:1/fc:1-1/fc]';
                        plot(x,signals(:,h),"LineWidth", 1);

                        xlim([0, x(end)])
                        ylim([min(signals(:,h)) - 0.2 * abs(min(signals(:,h))), max(signals(:,h)) + 0.2 * abs(max(signals(:,h)))]); 

                        xlabel('time [s]')
                        ylabel('Voltage [mV]')

                        title(title_plot)

                    end
                    % Save the plot
                    file_name="MAP_"+i+"_sub_"+num2str(j)+'_record_'+num2str(h)+'_';
                    save_plot(file_name, type_plots(l), figure_path, fig, true);
                end

             

            end
        end
    end
end