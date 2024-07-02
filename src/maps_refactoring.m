function MAP_out=maps_refactoring(MAP,path)

% Impostazione dei valori di default per gli argomenti
if nargin < 2 || isempty(path)
    save = false;  
    path = '';
else
    save=true;
end


% Finding signals into maps
signals=MAP{:,1};
rov_idx = find(strcmp(signals, 'rov trace:'));
if length(rov_idx)>1
    rov_idx=rov_idx(end,end);
end

ref_idx = find(strcmp(signals, 'ref trace:'));
if length(ref_idx)>1
    ref_idx=ref_idx(end,end);
end

spare1_idx = find(strcmp(signals, 'spare1 trace:'));
if length(spare1_idx)>1
    spare1_idx=spare_idx(end,end);
end

spare2_idx = find(strcmp(signals, 'spare2 trace:'));
if length(spare2_idx)>1
    spare2_idx=spare2_idx(end,end);
end

spare3_idx = find(strcmp(signals, 'spare3 trace:'));
if length(spare3_idx)>1
    spare3_idx=spare3_idx(end,end);
end

end_idx=find(strcmp(signals, 'FFT spectrum is available for FFT maps only'));

% Extraction of data tables
MAP_out.rov_trace=MAP(rov_idx+1:ref_idx-1,2:end);
MAP_out.ref_trace=MAP(ref_idx+1:spare1_idx-1,2:end);
MAP_out.spare1_trace=MAP(spare1_idx+1:spare2_idx-1,2:end);
MAP_out.spare2_trace=MAP(spare2_idx+1:spare3_idx-1,2:end);
MAP_out.spare3_trace=MAP(spare3_idx+1:end_idx-1,2:end);

%% Conversion of char into double
% To use properly the data in matlab these are converted into double from
% char. On the other hand, other lenguages recognize autonomously doubles
% from csv files, so it's not required such conversion before saving the
% struct. 

% fields name
names_struct = fieldnames(MAP_out);
for j = 1:numel(names_struct)
    tab = MAP_out.(names_struct{j});
    variable_names = tab.Properties.VariableNames;
    % variables iteration
    for i = 1:numel(variable_names)

        char_col = tab.(variable_names{i});
        if iscell(char_col)
            double_col = str2double(char_col);
            tab.(variable_names{i}) = double_col;
        end

    end
    % converted table assigment
    MAP_out.(names_struct{j}) = tab;
end

% Extraction of data tables
MAP_out_csv=MAP(rov_idx:end_idx-1,1:end);
% saving

if save
    writetable(MAP_out_csv,path)
end

end
