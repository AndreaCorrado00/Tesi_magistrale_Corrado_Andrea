% This function extracts the names and associated values of specific traces from a given map.
% It identifies the rows corresponding to the desired traces ('rov trace:', 'ref trace:', 
% 'spare1 trace:', 'spare2 trace:', 'S 3 trace:') and retrieves their respective values.
% The output is a table with two columns: trace names and their associated values.
% Inputs:
%   MAP - A table containing signal information in its first column and corresponding values
%         in its second column.
% Outputs:
%   names_of_traces - A table with two columns:
%       'Trace'      - The names of the extracted traces.
%       'Derivation' - The associated values of the extracted traces.

function names_of_traces = extract_names(MAP)

    % Finding signals in the map data
    signals = MAP{:,1};

    % Extracting indices of the desired traces
    rov_name_idx = find(strcmp(signals, 'rov trace:'), 1);
    ref_name_idx = find(strcmp(signals, 'ref trace:'), 1);
    spare1_name_idx = find(strcmp(signals, 'spare1 trace:'), 1);
    spare2_name_idx = find(strcmp(signals, 'spare2 trace:'), 1);
    spare3_name_idx = find(strcmp(signals, 'S 3 trace:'), 1);

    % Creating trace names
    trace_names = {'rov trace', 'ref trace', 'spare1 trace', 'spare2 trace', 'spare3 trace'};

    % Extracting values associated with each trace
    trace_values = table2array(MAP(rov_name_idx:spare3_name_idx, 2));

    % Creating the output table with two columns: trace names and their values
    names_of_traces = table(trace_names', trace_values, 'VariableNames', {'Trace', 'Derivation'});

end
