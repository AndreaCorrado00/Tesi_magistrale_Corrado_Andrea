function compare_traces_between_sub(data,fc,figure_path)
table_pox=[false,true;
            true,true];

type_plots=["comp_case_by_sign"; "comp_case_spectrum_by_sign"];
for l = 1:2
    for i = ["A","B","C"]
        map = 'MAP_' + i;
        subjects = fieldnames(data.(map));
        for k = ["rov","ref","spare1","spare2","spare3"]
            for j = 1:length(subjects)
                sub = map + num2str(j);
                trace = k + '_trace';
                title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), trace:' + k + ', subjects comparison';
                fig = figure(1);
                fig.WindowState = "maximized";
                hold on
                compare_by_plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l));
                
                legend_entries{j} = ['Subject ' num2str(j)];
            end  
            legend(legend_entries);
            hold off
            save_plot(i, '', k, type_plots(l), figure_path+"\traces_comp", fig, true);
        end
    end
end
end
