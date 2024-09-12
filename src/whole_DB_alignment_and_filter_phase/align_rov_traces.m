function new_signal=align_rov_traces(FP,RP,signal)

% Evaluation of the distance between FP (fiducial point) and RP (reference
% point)
distance = RP - FP;

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
end
