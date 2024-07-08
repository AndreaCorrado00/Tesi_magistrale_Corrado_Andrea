function Apen_dataset=apen_dataset_builder(data,m,r)

for l=1:2
    for i=["A","B","C"]
        map='MAP_'+i;
        subjects=fieldnames(data.(map));
        for j=1:length(subjects)
            sub=map+num2str(j);
            traces=fieldnames(data.(string(map)).(string(sub)));
            for k=["rov","ref","spare1","spare2","spare3"]
                trace=k+'_trace';
                signals_table=data.(map).(sub).(trace);
                apen_row=[];

                [M,N]=size(signals_table);
                for l=1:N
                    m=round(log(M) / log(100));
                    r=round(sqrt(var(table2array(signals_table(:,l)))));
                    apen_row(l)=ApEn(table2array(signals_table(:,l)),m,r);
                end
            end
            Apen_dataset.(map).(sub).(trace)=apen_row;

        
        end
    end
end