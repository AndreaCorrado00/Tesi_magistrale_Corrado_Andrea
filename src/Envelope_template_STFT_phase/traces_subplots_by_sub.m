function traces_subplots_by_sub(data,env_data, fc,sg_title,figure_path)

    
% Define plot types
type_plots = ["single_record"];


% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j =  1:length(subjects)
        sub = subjects{j};
       


        [~, N] = size(data.(map).(sub).rov_trace);
        for h=1:N

            signal=data.(map).(sub).rov_trace{:,h};
            envelope=env_data.(map).(sub).rov_trace{:,h};
         
            x = [0:1/fc:1-1/fc]';

            sub_num=split(sub,'_');
            sub_num=split(sub_num{2},i);
            sub_num=sub_num{end};

            % Create a new figure
            fig = figure(1);
            fig.WindowState = "maximized";
            plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
            hold on
            plot(x,envelope,"LineWidth",1.5,"Color","#0072BD")



            title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num +' trace, record: '+num2str(h);
            full_title={string(sg_title);string(title_plot)};
            xlim([0, x(end)])
            ylim([min(signal,[],"omitnan") - 0.2 * abs(min(signal,[],"omitnan")), max(signal,[],"omitnan") + 0.2 * abs(max(signal,[],"omitnan"))]);

            xlabel('time [s]')
            ylabel('Voltage [mV]')

            title(full_title,"FontSize",14)
            % Save the plot
            file_name="MAP_"+i+"_sub_"+sub_num+'_record_'+num2str(h)+'_';
            save_plot(file_name, type_plots(1), figure_path, fig, true);
        end
    end
end
end
