function newData=substitute_QRS_pos_with_median(data,QRS_med)
newData=data;
maps=["MAP_A","MAP_B","MAP_C"];
n_sub=12;

for i=1:3
    for j=1:n_sub
        sub=maps(i)+num2str(j);
        for k=1:width(data.(maps(i)).(sub).QRS_position_ref_trace)
            newData.(maps(i)).(sub).QRS_position_ref_trace(k)={QRS_med};
        end
    end
end

end
