function table_corr=correlation_signals_within_maps(data,trace)



for i=1:length(fieldnames((data.MAP_A)))
    table_sub=[];
    for j=1:3
        for k=1:3
            subA="MAP_A"+num2str(i);
            subB="MAP_B"+num2str(i);
            subC="MAP_C"+num2str(i);
            mean_signals=[table2array(mean(data.MAP_A.(subA).(trace),2)),table2array(mean(data.MAP_B.(subB).(trace),2)),table2array(mean(data.MAP_C.(subC).(trace),2))];
            table_sub(j,k)=corr(mean_signals(:,j),mean_signals(:,k));

        end
    end
    table_sub=array2table(table_sub);
    table_sub.Properties.VariableNames={char("A "+trace);char("B "+trace);char("C "+trace)};
    table_sub.Properties.RowNames={char("A "+trace);char("B "+trace);char("C "+trace)};
    table_corr.("sub_"+num2str(i))=table_sub;
end


end

