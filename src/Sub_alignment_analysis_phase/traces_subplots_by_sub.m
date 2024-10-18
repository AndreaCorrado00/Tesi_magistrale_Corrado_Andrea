function traces_subplots_by_sub(data, fc, figure_path)

    
% Define plot types
type_plots = ["single_record"];


% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j =  1:length(subjects)
        sub = map + num2str(j);
       


        [~, N] = size(data.(map).(sub).rov_trace);
        for h=1:N
            % Create a new figure
            fig = figure(1);
            fig.WindowState = "maximized";
            traces_names=["rov", "ref", "spare1", "spare2", "spare3"];
            % Loop through each trace type and plot comparisons
            for k = 1:5
                subplot(5,1,k)
                trace = traces_names(k) + "_trace";
                title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + num2str(j) +', '+ traces_names(k)+' trace, record: '+num2str(h);
                signals=table2array(data.(map).(sub).(trace));

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
            save_plot(file_name, type_plots(1), figure_path, fig, true);
        end
    end
end
end
