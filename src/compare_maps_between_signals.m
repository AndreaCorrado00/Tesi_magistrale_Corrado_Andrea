function compare_maps_between_signals(data,fc,figure_path)
legend_entries=[];
table_pox=[false,true;
            true,true];

type_plots=["comp_sign_by_map"; "comp_sign_spec_by_map"];
maps=["A","B","C"];
for l = 1:2
    for k = ["rov","ref","spare1","spare2","spare3"]
        subjects = fieldnames(data.MAP_A);
        for j= 1:length(subjects)
            for i = 1:3
                map = 'MAP_' +maps(i);
                sub = map + num2str(j);
                trace = k + '_trace';
                
                title_plot = 'Trace:'+k'+', sub:' + num2str(j) + ', MAP comparison';
                fig = figure(1);
                fig.WindowState = "maximized";
                hold on
                compare_by_plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l));
                legend_entries{i} = ['MAP '+maps(i)];
            end  
            legend(legend_entries);
            hold off
            save_plot("", j, k, type_plots(l), figure_path+"\map_comp", fig, true);
        end
    end
end
    
end
