function [FP_pos,new_signal] = align_to_QRS(signal, QRS_pos, half_width)
    % align_to_QRS_ref - Aligns a signal to a QRS position based on the local maximum.
    %
    % Syntax: new_signal = align_to_QRS_ref(signal, QRS_pos, half_width, reference, plot_flag)
    %
    % Inputs:
    %    signal - The signal to be aligned.
    %    QRS_pos - The position of the QRS complex in the reference signal.
    %    half_width - The width of the window around the QRS to be considered for alignment.
    %    reference - The reference signal used for comparison and plotting.
    %    plot_flag - Boolean to control whether to visualize the alignment process.
    %
    % Outputs:
    %    new_signal - The aligned signal, adjusted based on the position of the maximum relative to the QRS.

    %% Finding the local maximum
    % Define the neighborhood around the QRS and a vector of indices to ensure the maximum found is local and not repeated across the signal.
    [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref(signal, QRS_pos, half_width);

    % Position of the maximum value within the neighborhood
    max_pos_into_neighbor = find(neighborhood == max(neighborhood),1);
    
    % 
    % % If the maximum occurs at multiple points, select only the first one
    % if length(max_pos_into_neighbor) > 1
    %     max_pos_into_neighbor = max_pos_into_neighbor(1); % take only the first point
    % end

    % Translate the maximum position from the neighborhood to the full signal
    max_pos_into_signal = neighbor_idx(max_pos_into_neighbor);
    FP_pos=max_pos_into_signal;

    % Distance between the QRS position and the identified maximum in the signal
    distance = QRS_pos - max_pos_into_signal;

    %% Rebuilding the signal
    % % Display the signal before alignment, if requested
    % if plot_flag
    %     figure(1)
    %     subplot(211)
    %     x = [0:1/2035:1-1/2035]';
    %     plot(x, signal, 'b-') % Original signal in blue
    %     hold on
    %     plot(max_pos_into_signal / 2035, max(neighborhood), 'ro') % Local maximum marked with a red circle
    %     plot(neighbor_idx / 2035, neighborhood, 'k--') % Neighborhood in black dashed lines
    %     hold off
    %     title('Before alignment')
    %     subplot(212)
    %     plot(x, reference, 'b-') % Reference signal in blue
    %     hold on
    %     plot(QRS_pos / 2035, reference(QRS_pos), 'ro') % QRS position marked with a red circle
    %     hold off
    %     pause(0.2)
    % end

    % Adjust the signal based on the distance between the maximum and the QRS
    if distance > 0
        % Maximum is before the QRS --> NaN padding at the top, removing signal points from the bottom
        new_signal = [nan(distance, 1); signal(1:end - distance)];

    elseif distance < 0
        % Maximum is after the QRS --> Removing signal points from the top and adding NaN padding at the bottom
        new_signal = [signal(abs(distance) + 1:end); nan(abs(distance), 1)];

    else
        % If the maximum is exactly at the QRS position, no adjustment is needed
        new_signal = signal;
    end

    % % Display the signal after alignment, if requested
    % if plot_flag
    %     figure(1)
    %     subplot(211)
    %     x = [0:1/2035:1-1/2035]';
    %     plot(x, new_signal, 'b-') % Aligned signal in blue
    %     hold on
    %     plot(max_pos_into_signal / 2035, max(neighborhood), 'ro') % Local maximum marked
    %     hold off
    %     title('After alignment')
    %     subplot(212)
    %     plot(x, reference, 'b-') % Reference signal
    %     hold on
    %     plot(QRS_pos / 2035, reference(QRS_pos), 'ro') % QRS position
    %     hold off
    %     pause(0.2)
    % end

end
