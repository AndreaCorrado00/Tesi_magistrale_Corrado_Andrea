function newData=extract_single_subs(data, vec_subs)
newData=struct;

map_names=["A","B","C"];
for i=1:3
    map="MAP_"+map_names(i);
    sub_names=fieldnames(data.(map));
    sub_names=sub_names(vec_subs);

    for j=1:length(sub_names)
        newData.(map).(string(sub_names(j)))=data.(map).(string(sub_names(j)));
    end

end

end
