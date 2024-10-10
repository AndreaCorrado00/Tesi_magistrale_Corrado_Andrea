function names_of_traces = extract_names(MAP)

% Finding signals in the map data
signals = MAP{:,1};

% Estrazione degli indici delle tracce desiderate
rov_name_idx = find(strcmp(signals, 'rov trace:'), 1);
ref_name_idx = find(strcmp(signals, 'ref trace:'), 1);
spare1_name_idx = find(strcmp(signals, 'spare1 trace:'), 1);
spare2_name_idx = find(strcmp(signals, 'spare2 trace:'), 1);
spare3_name_idx = find(strcmp(signals, 'S 3 trace:'), 1);

% Creazione dei nomi delle tracce
trace_names = {'rov trace', 'ref trace', 'spare1 trace', 'spare2 trace', 'spare3 trace'};

% Estrazione dei valori associati a ciascuna traccia
trace_values = table2array(MAP(rov_name_idx: spare3_name_idx, 2));

% Creazione della tabella di output con due colonne: nomi delle tracce e i loro valori
names_of_traces = table(trace_names', trace_values, 'VariableNames', {'Trace', 'Derivation'});

end


