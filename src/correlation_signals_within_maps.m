function table_corr = correlation_signals_within_maps(data, trace)
% correlation_signals_within_maps calculates correlations between mean signals
% within maps A, B, and C stored in the structure data.
%
% Inputs:
%   - data: Structure containing maps MAP_A, MAP_B, MAP_C.
%   - trace: String specifying the trace type (e.g., 'trace1', 'trace2').
%
% Output:
%   - table_corr: Structure containing correlation tables for each MAP_A, MAP_B,
%     and MAP_C.
%

% Iterate over the number of MAP_A maps in the data structure
for i = 1:length(fieldnames(data.MAP_A))
    table_sub = [];
    % Iterate over rows (j) and columns (k) of the 3x3 table_sub matrix
    for j = 1:3
        for k = 1:3
            % Construct field names for MAP_A, MAP_B, MAP_C
            subA = "MAP_A" + num2str(i);
            subB = "MAP_B" + num2str(i);
            subC = "MAP_C" + num2str(i);
            
            % Calculate mean signals for MAP_A, MAP_B, MAP_C
            mean_signals = [
                table2array(mean(data.MAP_A.(subA).(trace), 2)), ...
                table2array(mean(data.MAP_B.(subB).(trace), 2)), ...
                table2array(mean(data.MAP_C.(subC).(trace), 2))
            ];
            
            % Calculate correlation between columns j and k of mean_signals
            table_sub(j, k) = corr(mean_signals(:, j), mean_signals(:, k));
        end
    end
    
    % Convert table_sub from array to table format
    table_sub = array2table(table_sub);
    
    % Set variable and row names for table_sub
    table_sub.Properties.VariableNames = {char("A " + trace), char("B " + trace), char("C " + trace)};
    table_sub.Properties.RowNames = {char("A " + trace), char("B " + trace), char("C " + trace)};
    
    % Store table_sub in table_corr structure with field name "sub_i"
    table_corr.("sub_" + num2str(i)) = table_sub;
end

end
