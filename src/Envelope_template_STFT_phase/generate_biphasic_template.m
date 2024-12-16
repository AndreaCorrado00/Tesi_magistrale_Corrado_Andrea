function template = generate_biphasic_template(Fs, duration, smoothing_window)
    % Fs: sampling frequency (Hz)
    % duration: duration of the biphasic signal (s)
    % smoothing_window: size of the window for smoothing (samples)

    % Calculate the number of samples
    N = round(duration * Fs);

    % Define the biphasic structure
    % First third: ascending phase
    x1 = linspace(0, 1, round(N / 3));
    % Second third: descending phase
    x2 = linspace(1, -1, round(N / 3));
    % Final third: return to zero
    x3 = linspace(-1, 0, N - length(x1) - length(x2));
    
    % Build the biphasic signal
    template = [x1, x2, x3];

    % Smooth the edges
    template = smoothdata(template, 'gaussian', smoothing_window);
   
    % % Plot the template
    % time = (0:N-1) / Fs; % Time axis
    % figure;
    % plot(time, template, '-');
    % title("Biphasic Template  of duration: "+ num2str(duration)+ " seconds");
    % xlabel('Time [s]');
end
