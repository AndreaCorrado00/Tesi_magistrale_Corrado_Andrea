function unique_dataset=remove_repeated_signals(data)
unique_dataset=data;

for i=["A","B","C"]
    map="MAP_"+i;

     subjects = fieldnames(data.(map));

     for j=1:length(subjects)
         sub=subjects{j};
         if isfield(data.(map).(sub), 'rov_trace')
             rov_original=table2array(data.(map).(sub).rov_trace);

             % finding unique signals
             [unique_rov,uniqueIdx,~]=unique(rov_original',"rows","stable");

             % cleaning other traces
             allIndices = 1:size(rov_original, 2);

             unique_dataset.(map).(sub).rov_trace=array2table(unique_rov');
             unique_dataset.(map).(sub).ref_trace=data.(map).(sub).ref_trace(:,uniqueIdx);
             unique_dataset.(map).(sub).spare1_trace=data.(map).(sub).spare1_trace(:,uniqueIdx);
             unique_dataset.(map).(sub).spare2_trace=data.(map).(sub).spare2_trace(:,uniqueIdx);
             unique_dataset.(map).(sub).spare3_trace=data.(map).(sub).spare3_trace(:,uniqueIdx);
             unique_dataset.(map).(sub).n_duplicates=length(allIndices)-length(uniqueIdx);
         end
         
     end

end
