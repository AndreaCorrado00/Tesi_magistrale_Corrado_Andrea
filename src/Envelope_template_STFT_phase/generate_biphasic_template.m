function template = generate_biphasic_template(Fs, duration, smoothing_window)
    % Fs: sampling frequency (Hz)
    % duration: desired duration of the biphasic signal (s)
    % smoothing_window: size of the window for smoothing (samples)

    % Adjust duration to nearest multiple of 1/Fs
    N = round(duration * Fs);       % Total number of samples
    duration = N / Fs;              % Adjusted duration in seconds

    % Calculate the number of samples for half duration
    N_half = round(N / 2);
    
    % Generate the first half: ascending and descending (0 -> 1 -> 0)
    x1 = linspace(0, 1, round(N_half / 2));  % Ascending phase
    x2 = flip(x1); % Descending phase
    first_half = [x1, x2];
    
    % Generate the second half by reflecting the first half
    second_half = -first_half;

    % Combine the two halves
    template = [first_half(1:end-1), second_half];

    % Smooth the entire signal if required
    if smoothing_window > 0
        template = smoothdata(template, 'gaussian', smoothing_window);
    end
    
    % % Plot the template
    % time = (0:length(template)-1) / Fs; % Time axis
    % figure;
    % plot(time, template, '-');
    % title("Biphasic Template of duration: " + num2str(round(duration,3)) + " seconds");
    % xlabel('Time [s]');
    % xlim([0,duration])
end
