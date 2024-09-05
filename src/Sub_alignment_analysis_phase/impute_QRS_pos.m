function QRS_imputed = impute_QRS_pos(QRS_pos)
    % impute_QRS_pos - Imputes missing QRS positions with the median of available positions.
    %
    % Syntax: QRS_imputed = impute_QRS_pos(QRS_pos)
    %
    % Inputs:
    %    QRS_pos - Cell array containing QRS positions. Some cells may be empty.
    %
    % Outputs:
    %    QRS_imputed - Cell array with the same structure as QRS_pos, but with
    %                  missing values (originally empty cells) replaced by the median of the non-empty values.
    %
    % This function takes a cell array of QRS positions where some entries may be empty (indicating missing data).
    % It replaces these empty cells with the median value of the non-empty QRS positions, ensuring that all entries
    % have a valid value for subsequent analysis.

    % Initialize QRS_imputed as a copy of the input QRS_pos
    QRS_imputed = QRS_pos;

    % Replace empty cells in QRS_pos with NaN to facilitate numerical operations
    QRS_pos(cellfun(@isempty, QRS_pos)) = {NaN};
    
    % Convert the cell array QRS_pos to a numeric matrix
    QRS_pos = cell2mat(QRS_pos);
    
    % Calculate the median of the non-NaN QRS positions
    med = round(median(QRS_pos, "omitnan"));
    
    % Replace the NaN values in QRS_imputed with the calculated median value
    QRS_imputed(isnan(QRS_pos)) = {med};
end
