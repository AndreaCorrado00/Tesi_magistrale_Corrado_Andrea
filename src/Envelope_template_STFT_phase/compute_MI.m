function MI_value = compute_MI(signal,fs)
    % Define the useful part of the signal (0.15 to 0.65 seconds)
    signal_length = length(signal); % Length of the signal
    start_index = round(0.15 * fs); % Start index for 0.15s
    end_index = round(0.65 * fs); % End index for 0.65s
    
    % Extract the useful part of the signal
    useful_signal = signal(start_index:end_index);
    
    % Define the segments: 250 ms (0.25s) segments
    segment1 = useful_signal(1:round(0.25 * fs)+1);  % First segment (0.15s to 0.4s)
    segment2 = useful_signal(round(0.25 * fs) + 1:end);  % Second segment (0.4s to 0.65s)
    
    % Calculate the Mutual Information (MI) between the two segments
    MI_value = mutual_information(segment1, segment2);
end


