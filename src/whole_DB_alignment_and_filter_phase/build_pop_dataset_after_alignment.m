function pop_dataset_aligned=build_pop_dataset_after_alignment(data)


map_names=["MAP_A","MAP_B","MAP_C"];
n_sub=length(fieldnames(data.MAP_A));

for i=1:3
    rov_records=[];
    ref_records=[];
    spare1_records=[];
    spare2_records=[];
    spare3_records=[];
    map=map_names(i);
    for j=1:n_sub
        sub=map+num2str(j);
        rov_records=[rov_records,table2array(data.(map).(sub).rov_trace)];
        ref_records=[ref_records,table2array(data.(map).(sub).ref_trace)];
        spare1_records=[spare1_records,table2array(data.(map).(sub).spare1_trace)];
        spare2_records=[spare2_records,table2array(data.(map).(sub).spare2_trace)];
        spare3_records=[spare3_records,table2array(data.(map).(sub).spare3_trace)];
    end
    pop_dataset_aligned.(map).rov_trace=array2table(rov_records);
    pop_dataset_aligned.(map).ref_trace=array2table(ref_records);
    pop_dataset_aligned.(map).spare1_trace=array2table(spare1_records);
    pop_dataset_aligned.(map).spare2_trace=array2table(spare2_records);
    pop_dataset_aligned.(map).spare3_trace=array2table(spare3_records);

end

