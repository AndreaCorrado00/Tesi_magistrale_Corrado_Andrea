function MAP_out = maps_refactoring(MAP, path)
% maps_refactoring refactors MAP structure by extracting and converting trace data.
% Optionally, it saves the refactored data to a specified path.
%
% Inputs:
%   - MAP: Table containing the map data.
%   - path: Optional. String specifying the file path to save the refactored data.
%
% Output:
%   - MAP_out: Structure containing refactored trace data.
%

% Check if the path argument is provided
if nargin < 2 || isempty(path)
    % If not provided, set save flag to false and path to empty string
    save = false;  
    path = '';
else
    % If provided, set save flag to true
    save = true;
end

% Finding signals in the map data
signals = MAP{:,1};

rov_idx = find(strcmp(signals, 'rov trace:'));
if length(rov_idx) > 1
    rov_idx = rov_idx(end, end);
end

ref_idx = find(strcmp(signals, 'ref trace:'));
if length(ref_idx) > 1
    ref_idx = ref_idx(end, end);
end

spare1_idx = find(strcmp(signals, 'spare1 trace:'));
if length(spare1_idx) > 1
    spare1_idx = spare1_idx(end, end);
end

spare2_idx = find(strcmp(signals, 'spare2 trace:'));
if length(spare2_idx) > 1
    spare2_idx = spare2_idx(end, end);
end

spare3_idx = find(strcmp(signals, 'spare3 trace:'));
if length(spare3_idx) > 1
    spare3_idx = spare3_idx(end, end);
end 

end_idx = find(strcmp(signals, 'FFT spectrum is available for FFT maps only'));

% Extraction of data tables for each trace type
MAP_out.rov_trace = varfun(@(x) str2double(x), MAP(rov_idx + 1:ref_idx - 1, 2:end));
MAP_out.ref_trace =varfun(@(x) str2double(x),  MAP(ref_idx + 1:spare1_idx - 1, 2:end));
MAP_out.spare1_trace = varfun(@(x) str2double(x), MAP(spare1_idx + 1:spare2_idx - 1, 2:end));
MAP_out.spare2_trace = varfun(@(x) str2double(x), MAP(spare2_idx + 1:spare3_idx - 1, 2:end));
MAP_out.spare3_trace = varfun(@(x) str2double(x), MAP(spare3_idx + 1:end_idx - 1, 2:end));

% Conversion of char into double
% To use the data properly in MATLAB, these are converted from char to double.
% Other languages recognize doubles from CSV files autonomously, so conversion
% is not required before saving the struct.

% Get field names of the structure
names_struct = fieldnames(MAP_out);
for j = 1:numel(names_struct)
    tab = MAP_out.(names_struct{j});
    variable_names = tab.Properties.VariableNames;
    % Iterate over variables
    for i = 1:numel(variable_names)
        char_col = tab.(variable_names{i});
        if iscell(char_col)
            double_col = str2double(char_col);
            tab.(variable_names{i}) = double_col;
        end
    end
    % Assign converted table back to structure
    MAP_out.(names_struct{j}) = tab;
end

% Extraction of the complete data table for CSV saving
MAP_out_csv = MAP(rov_idx:end_idx - 1, 1:end);

% Saving the data table to the specified path if save flag is true
if save
    writetable(MAP_out_csv, path)
end

end

