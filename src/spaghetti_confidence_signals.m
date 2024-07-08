function spaghetti_confidence_signals(data,fc,figure_path)
table_pox=[false,false,;
            false,true ;
            true, false;
            true, true];
type_plots=["spaghetti";"confidence"; "spaghetti_freq"; "confidence_freq"];
% spaghetti time domain
% confidence time domain
% spaghetti spectral
% confidence spectral

for l=1:4
    for i=["A","B","C"]
        map='MAP_'+i;
        subjects=fieldnames(data.(map));
        for j=1:length(subjects)
            sub=map+num2str(j);
            traces=fieldnames(data.(string(map)).(string(sub)));
            for k=["rov","ref","spare1","spare2","spare3"]
                trace=k+'_trace';
                title_plot='MAP:'+i+' ('+get_name_of_map(i)+')'+', sub:'+num2str(j)+', trace: '+k;
                fig=figure(1);
                fig.WindowState="maximized";
                plotting_signals(data.(map).(sub).(trace),title_plot,fc,table_pox(l,1),table_pox(l,2))
                fig=gcf;
                save_plot(i,j,k,type_plots(l),figure_path+"\data_visual",fig,true);
            end
        end
    end
end
end
