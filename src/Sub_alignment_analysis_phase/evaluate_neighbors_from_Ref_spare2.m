function [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref_spare2(signal, QRS_ref, QRS_spare2, half_width, tollerance)
    % evaluate_neighbors_from_Ref_spare2 - Extracts a neighborhood around the QRS complex based on reference and spare2 signals.
    %
    % Syntax: [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref_spare2(signal, QRS_ref, QRS_spare2, half_width, tollerance)
    %
    % Inputs:
    %    signal - Vector containing the signal data.
    %    QRS_ref - QRS position from the reference signal.
    %    QRS_spare2 - QRS position from the spare2 signal.
    %    half_width - Number of samples defining half the width of the neighborhood window.
    %    tollerance - Maximum allowed difference between QRS_ref and QRS_spare2 to choose the reference point.
    %
    % Outputs:
    %    neighborhood - Segment of the signal surrounding the chosen QRS position.
    %    neighbor_idx - Indices of the original signal corresponding to the extracted neighborhood.
    %
    % This function determines the neighborhood around a QRS complex in a signal based on the QRS positions from two sources: 
    % a reference signal (QRS_ref) and a secondary signal (QRS_spare2). The neighborhood is centered around QRS_ref if the
    % difference between QRS_ref and QRS_spare2 exceeds the specified tolerance; otherwise, it is centered around QRS_spare2.

    % Check if the difference between QRS_ref and QRS_spare2 exceeds the tolerance
    if abs(QRS_ref - QRS_spare2) > tollerance 
        % If the neighborhood around QRS_ref extends beyond the signal end
        if QRS_ref + half_width > length(signal)
            neighborhood = signal(QRS_ref - half_width:end);  % Extract from (QRS_ref - half_width) to the end
            neighbor_idx = QRS_ref - half_width:length(signal); % Indices for the extracted neighborhood
            
        % If the neighborhood around QRS_ref extends before the start of the signal
        elseif QRS_ref - half_width < 1 
            neighborhood = signal(1:QRS_ref + half_width);  % Extract from start to (QRS_ref + half_width)
            neighbor_idx = 1:QRS_ref + half_width;  % Indices for the extracted neighborhood
            
        % If the neighborhood is fully within the signal range
        else
            neighborhood = signal(QRS_ref - half_width:QRS_ref + half_width);  % Extract centered on QRS_ref
            neighbor_idx = QRS_ref - half_width:QRS_ref + half_width;  % Indices for the extracted neighborhood
        end
        
    % If the difference is within the tolerance, center the neighborhood around QRS_spare2
    else
        % If the neighborhood around QRS_spare2 extends beyond the signal end
        if QRS_spare2 + half_width > length(signal)
            neighborhood = signal(QRS_spare2 - half_width:end);  % Extract from (QRS_spare2 - half_width) to the end
            neighbor_idx = QRS_spare2 - half_width:length(signal); % Indices for the extracted neighborhood
            
        % If the neighborhood around QRS_spare2 extends before the start of the signal
        elseif QRS_spare2 - half_width < 1
            neighborhood = signal(1:QRS_spare2 + half_width);  % Extract from start to (QRS_spare2 + half_width)
            neighbor_idx = 1:QRS_spare2 + half_width;  % Indices for the extracted neighborhood
            
        % If the neighborhood is fully within the signal range
        else
            neighborhood = signal(QRS_spare2 - half_width:QRS_spare2 + half_width);  % Extract centered on QRS_spare2
            neighbor_idx = QRS_spare2 - half_width:QRS_spare2 + half_width;  % Indices for the extracted neighborhood
        end
    end
end
