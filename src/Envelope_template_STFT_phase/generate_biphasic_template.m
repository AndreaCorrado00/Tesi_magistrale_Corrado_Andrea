function template = generate_biphasic_template(Fs, duration, smoothing_window)
    % generate_biphasic_template Generates a synthetic biphasic signal with an
    % ascending and descending phase, followed by an inverted version of the same 
    % structure. Optionally smooths the signal using a Gaussian filter.
    %
    % Input:
    %   Fs (numeric)         - Sampling frequency in Hz (samples per second).
    %   duration (numeric)   - Desired duration of the biphasic signal in seconds.
    %   smoothing_window (numeric) - The size of the smoothing window (in samples)
    %                                used to smooth the signal, if applicable.
    %
    % Output:
    %   template (numeric array) - The generated biphasic signal after optional smoothing.
    %
    % The signal consists of two halves:
    % 1. The first half is a biphasic waveform (ascending from 0 to 1, then descending from 1 to 0).
    % 2. The second half is the inverse of the first half (negated version of the first half).

    % Adjust the duration to the nearest multiple of 1/Fs to ensure the signal fits within the desired length
    N = round(duration * Fs);       % Total number of samples
    duration = N / Fs;              % Adjusted duration in seconds (in case rounding was necessary)

    % Calculate the number of samples for half the duration
    N_half = round(N / 2);
    
    % Generate the first half: ascending and descending (0 -> 1 -> 0)
    x1 = linspace(0, 1, round(N_half / 2));  % Ascending phase from 0 to 1
    x2 = flip(x1);  % Descending phase, flipped from x1 (from 1 back to 0)
    first_half = [x1, x2];  % Combine both ascending and descending phases

    % Generate the second half by reflecting (negating) the first half
    second_half = -first_half;  % Inverse of the first half (flipped vertically)

    % Combine both halves to form the complete biphasic template
    template = [first_half(1:end-1), second_half];  % Ensure no overlap at the transition

    % Smooth the entire signal using a Gaussian filter, if smoothing_window > 0
    if smoothing_window > 0
        % Apply Gaussian smoothing with the specified window size
        template = smoothdata(template, 'gaussian', smoothing_window);
    end
    
    % % Optional Plotting:
    % time = (0:length(template)-1) / Fs;  % Time axis for plotting
    % figure;
    % plot(time, template, '-',"LineWidth",1.2);  % Plot the signal
    % title("Biphasic Template of duration: " + num2str(round(duration,3)) + " seconds", "FontSize",16);
    % xlabel('Time [s]',"FontSize",16);
    % xlim([0, duration])  % Set the x-axis limit to the desired duration
end
