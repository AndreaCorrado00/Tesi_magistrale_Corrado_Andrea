function QRS_vec=build_and_plot_QRS_distribution(data)
maps=["MAP_A","MAP_B","MAP_C"];
n_sub=12;
QRS_vec=[];
for i=1:3
    for j=1:n_sub
        sub=maps(i)+num2str(j);
        QRS_vec=[QRS_vec;cell2mat(data.(maps(i)).(sub).QRS_position_ref_trace)'];

    end
end

figure(1)
boxplot(QRS_vec)
title('QRS location distribution')
xlabel('QRS positions')

end
