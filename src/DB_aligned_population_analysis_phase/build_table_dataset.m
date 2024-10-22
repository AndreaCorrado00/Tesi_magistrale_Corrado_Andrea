function db_table = build_table_dataset(data)


map_names = ["MAP_A", "MAP_B", "MAP_C"];
    
db_table=table();

for i = 1:3
    map = map_names(i);
    
    map_signals=table2array(data.(map).rov_trace);
    
    map_signals=[map_signals',repmat(map,height(map_signals'),1)];

    db_table=vertcat(db_table,array2table(map_signals));
end
variableNames = cell(1, width(map_signals)); 
for i = 1:width(map_signals)-1
    variableNames{i} = num2str(i); % basically the point number
end
variableNames{end} = 'class'; % class name

db_table.Properties.VariableNames=variableNames; 

end
