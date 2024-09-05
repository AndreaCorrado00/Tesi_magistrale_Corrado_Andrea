function [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref(signal, QRS_pos, half_width)
    % evaluate_neighbors_from_Ref - Extracts a neighborhood around a QRS position in a signal.
    %
    % Syntax: [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref(signal, QRS_pos, half_width)
    %
    % Inputs:
    %    signal - Vector containing the signal data.
    %    QRS_pos - Position of the QRS complex in the signal.
    %    half_width - Number of samples defining half the width of the neighborhood window.
    %
    % Outputs:
    %    neighborhood - Segment of the signal surrounding the QRS position.
    %    neighbor_idx - Indices of the original signal corresponding to the extracted neighborhood.
    %
    % This function extracts a segment of the signal centered around a given QRS position.
    % The segment width is determined by the `half_width` parameter. The function handles cases where the
    % neighborhood extends beyond the boundaries of the signal.

    % Check if the neighborhood around QRS_pos extends beyond the end of the signal
    if QRS_pos + half_width > length(signal)
        % Extract the segment from (QRS_pos - half_width) to the end of the signal
        neighborhood = signal(QRS_pos - half_width:end); 
        % Generate the corresponding indices
        neighbor_idx = QRS_pos - half_width:length(signal);

    % Check if the neighborhood around QRS_pos extends before the start of the signal
    elseif QRS_pos - half_width < 1
        % Extract the segment from the start of the signal to (QRS_pos + half_width)
        neighborhood = signal(1:QRS_pos + half_width);
        % Generate the corresponding indices
        neighbor_idx = 1:QRS_pos + half_width;

    % If the neighborhood is fully within the bounds of the signal
    else
        % Extract the segment centered on QRS_pos with the specified half-width
        neighborhood = signal(QRS_pos - half_width:QRS_pos + half_width);
        % Generate the corresponding indices
        neighbor_idx = QRS_pos - half_width:QRS_pos + half_width;
    end
end
