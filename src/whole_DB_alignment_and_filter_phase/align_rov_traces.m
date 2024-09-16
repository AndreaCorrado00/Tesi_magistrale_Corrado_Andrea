function new_signal = align_rov_traces(FP, RP, signal)
    % Aligns the input signal based on the fiducial point (FP) and the reference point (RP).
    % Adjusts the signal by padding with NaNs or trimming based on the distance between FP and RP.
    %
    % INPUTS:
    %   FP - Fiducial point (index) in the signal
    %   RP - Reference point (index) in the signal
    %   signal - ECG signal to be aligned
    %
    % OUTPUT:
    %   new_signal - Aligned ECG signal with NaN padding as needed

    % Evaluate the distance between FP and RP
    distance = RP - FP;

    if distance > 0
        % If FP is before RP, pad with NaNs at the start and trim the end
        new_signal = [nan(distance, 1); signal(1:end - distance)];
    elseif distance < 0
        % If FP is after RP, trim the start and pad with NaNs at the end
        new_signal = [signal(abs(distance) + 1:end); nan(abs(distance), 1)];
    else
        % If FP and RP are the same, no adjustment needed
        new_signal = signal;
    end
end