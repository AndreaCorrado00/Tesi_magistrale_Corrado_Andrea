function compare_case_signals(data,fc,figure_path)
table_pox=[false,true;
            true,true];

type_plots=["comp_sig_mean_by_case"; "comp_sig_spectrum_by_case"];
for l=1:2
    for i=["A","B","C"]
        map='MAP_'+i;
        subjects=fieldnames(data.(map));
        for j=1:length(subjects)
            sub=map+num2str(j);
            traces=fieldnames(data.(string(map)).(string(sub)));
            for k=["rov","ref","spare1","spare2","spare3"]
                trace=k+'_trace';
                title_plot='MAP:'+i+' ('+get_name_of_map(i)+')'+', sub:'+num2str(j)+', traces comparison';
                fig=figure(1);
                fig.WindowState="maximized";
                hold on 
                compare_by_plotting_signals(data.(map).(sub).(trace),title_plot,fc,table_pox(1,l),table_pox(2,l))
            end
            legend('ROV','REF','SPARE 1','SPARE 2', 'SPARE 3')
            hold off
            save_plot(i,j,'',type_plots(l),figure_path+"\cases_comp",fig,true);
        end
    end
end