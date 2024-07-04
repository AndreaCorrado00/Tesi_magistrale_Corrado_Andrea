function plotting_signals(signals_table,title_plot,Fc,freq_plot,variability_plot)
mean_sig=table2array(mean(signals_table,2));
[M,N]=size(signals_table);
if freq_plot
    x=[]; %to be implemented
else
    x=[0:1/Fc:1-1/Fc]';
end

plot(x,mean_sig,'k-',"LineWidth",3)
hold on
if  ~variability_plot % mean VS all signals
    for i=1:N
        plot(x,table2array(signals_table(:,i)),':',"LineWidth",0.4)

    end
    hold off
    xlim([0,x(end)])
    min_y_lim=table2array(min(min(signals_table),[],2));
    max_y_lim=table2array(max(max(signals_table),[],2));
    ylim([min_y_lim-0.05*min_y_lim,max_y_lim+0.05*max_y_lim])
    title('Mean and single records: '+title_plot)

elseif variability_plot %mean and bands 95%
    % plotting avg +- 95% perc
    % costruzione delle bande
    up_lim=round(0.95*length(table2array(signals_table(1,:))));
    down_lim=round(0.05*length(table2array(signals_table(1,:))));
    if down_lim==0
        down_lim=1;
    end

    VAR_LIMS=[];
    % costruzione bande
    for i=1:M
        signals_i=sort(table2array(signals_table(i,:)));
        VAR_LIMS(i,1)=signals_i(down_lim);
        VAR_LIMS(i,2)=signals_i(up_lim);
    end
    plot(x,VAR_LIMS(:,1),'k:',"LineWidth",0.8)
    plot(x,VAR_LIMS(:,2),'k:',"LineWidth",0.8)
    xlim([0,x(end)])
    min_y_lim=min(VAR_LIMS(:,1));
    max_y_lim=max(VAR_LIMS(:,2));
    ylim([min_y_lim-0.05*min_y_lim,max_y_lim+0.05*max_y_lim])
    title('Mean and confidence intervals at 95%: ' +title_plot)
    hold off
   
end

end
