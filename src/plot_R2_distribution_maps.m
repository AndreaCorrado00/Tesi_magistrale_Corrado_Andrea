function plot_R2_distribution_maps(table_corr,trace,figure_path,make_ttest)
R2_vectors=[]; % corr(A,B), corr(B,C), corr(A,C)
for i=1:length(fieldnames(table_corr))
    sub="sub_"+num2str(i);
    tab=table_corr.(sub);
    R2_vectors(i,1)=table2array(tab(1,2));
    R2_vectors(i,2)=table2array(tab(2,3));
    R2_vectors(i,3)=table2array(tab(1,3));
end

maps_vs=["A-B","B-C", "A-C"];
for i=1:3
    % Create a new figure
    fig = figure(1);
    fig.WindowState = "maximized";
    hold on

    subplot(1,3,i)
    boxplot(R2_vectors(:,i))
    ylim([-1,1])
    title("R^2 for "+string(trace)'+", maps:"+maps_vs(i))


end
fig=gcf;
file_name="R2 distribution for "+string(trace)+" within maps";
save_plot(file_name," boxplot",figure_path+"\boxplots",fig,true);


if make_ttest
    tab_hp=[];
    tab_p=[];
    for i=1:3
        for j=1:3
            [h,p]=ttest(R2_vectors(:,i),R2_vectors(:,j));
            tab_hp(i,j)=h;
            tab_p(i,j)=p;

        end
    end
    tab_p=array2table(tab_p);
    tab_p.Properties.VariableNames={char("A");char("B");char("C")};
    tab_p.Properties.RowNames={char("A");char("B");char("C")};

    tab_hp=array2table(tab_hp);
    tab_hp.Properties.VariableNames={char("A");char("B");char("C")};
    tab_hp.Properties.RowNames={char("A");char("B");char("C")};

    disp("Results of T-Test for "+string(trace) )
    disp('HP table')
    disp(tab_hp)
    disp('----------------')
    disp('p-values table')
    disp(tab_p)
    disp('----------------')
end
end




