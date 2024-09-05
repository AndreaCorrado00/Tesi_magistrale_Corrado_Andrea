function new_signal = align_to_QRS_ref_and_spare2(signal, QRS_ref, QRS_spare2, half_width, reference, tollerance, plot_flag)
    % align_to_QRS_ref_and_spare2 - Aligns a signal to a QRS position based on two reference signals.
    %
    % Syntax: new_signal = align_to_QRS_ref_and_spare2(signal, QRS_ref, QRS_spare2, half_width, reference, tollerance, plot_flag)
    %
    % Inputs:
    %    signal - The signal to be aligned.
    %    QRS_ref - The position of the QRS complex in the reference signal.
    %    QRS_spare2 - The position of the QRS complex in the secondary reference signal.
    %    half_width - The half-width of the neighborhood around the QRS position to be considered for alignment.
    %    reference - The reference signal used for comparison and plotting.
    %    tollerance - The allowed difference between the QRS positions in the reference signals.
    %    plot_flag - Boolean flag to control whether the alignment process is visualized with plots.
    %
    % Outputs:
    %    new_signal - The aligned signal, adjusted based on the maximum value's position relative to the QRS complex.
    %
    % This function aligns a signal to a QRS position by identifying the local maximum within a neighborhood around
    % the QRS complex in either the reference or the secondary reference signal. The function handles cases where
    % the identified maximum is before or after the QRS position, adjusting the signal by padding with NaNs.

    %% Finding the maximum in the neighborhood
    % Determine the neighborhood around the QRS position in either the reference or secondary reference signal.
    [neighborhood, neighbor_idx] = evaluate_neighbors_from_Ref_spare2(signal, QRS_ref, QRS_spare2, half_width, tollerance);

    % Find the position of the maximum value within the neighborhood
    max_pos_into_neighbor = find(neighborhood == max(neighborhood));

    % If the maximum is found at multiple points, select the first occurrence
    if length(max_pos_into_neighbor) > 1
        max_pos_into_neighbor = max_pos_into_neighbor(1); % taking the first point
    end

    % Translate the neighborhood index to the signal index
    max_pos_into_signal = neighbor_idx(max_pos_into_neighbor);

    % Calculate the distance between the QRS position and the maximum position in the signal
    distance = QRS_ref - max_pos_into_signal;

    %% Rebuilding the signal
    % If plotting is enabled, visualize the signal before alignment
    if plot_flag
        figure(1)
        subplot(211)
        x = [0:1/2035:1-1/2035]';
        plot(x, signal, 'b-') % Original signal in blue
        hold on
        plot(max_pos_into_signal / 2035, max(neighborhood), 'ro') % Mark the maximum position with a red circle
        plot(neighbor_idx / 2035, neighborhood, 'k--') % Plot the neighborhood in black dashed lines
        hold off
        title('Before Alignment')
        subplot(212)
        plot(x, reference, 'b-') % Plot the reference signal
        hold on
        plot(QRS_ref / 2035, reference(QRS_ref), 'ro') % Mark the QRS position with a red circle
        hold off
        pause(0.2)
    end

    % Adjust the signal based on the distance between the maximum and QRS positions
    if distance > 0
        % If the maximum is before the QRS --> Add NaNs at the beginning, truncate the end
        new_signal = [nan(distance, 1); signal(1:end - distance)];

    elseif distance < 0
        % If the maximum is after the QRS --> Truncate the beginning, add NaNs at the end
        new_signal = [signal(abs(distance) + 1:end); nan(abs(distance), 1)];

    else
        % If the maximum is at the QRS position, no adjustment needed
        new_signal = signal;
    end

    % If plotting is enabled, visualize the signal after alignment
    if plot_flag
        figure(1)
        subplot(211)
        x = [0:1/2035:1-1/2035]';
        plot(x, new_signal, 'b-') % Aligned signal in blue
        hold on
        plot(max_pos_into_signal / 2035, max(neighborhood), 'ro') % Mark the maximum position again
        hold off
        title('After Alignment')
        subplot(212)
        plot(x, reference, 'b-') % Plot the reference signal
        hold on
        plot(QRS_ref / 2035, reference(QRS_ref), 'ro') % Mark the QRS position
        hold off
        pause(0.2)
    end
end
