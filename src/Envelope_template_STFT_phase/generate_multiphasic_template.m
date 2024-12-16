function template = generate_multiphasic_template(Fs, duration, smoothing_window)
    % Fs: sampling frequency (Hz)
    % duration: duration of the multiphasic signal (s)
    % smoothing_window: size of the window for smoothing (samples)

    % Calculate the number of samples
    N = round(duration * Fs);

    % Define the multiphasic structure
    % First segment: positive peak
    x1 = linspace(0, 0.5, round(N / 4));
    % Second segment: negative peak
    x2 = linspace(0.5, -1, round(N / 4));
    % Third segment: second positive peak
    x3 = linspace(-1, 0.5, round(N / 4));
    % Fourth segment: return to zero
    x4 = linspace(0.5, 0, N - length(x1) - length(x2) - length(x3));

    % Build the multiphasic signal
    template = [x1, x2, x3, x4];

    % Smooth the edges
    template = smoothdata(template, 'gaussian', smoothing_window);

    % Plot the template
    % time = (0:N-1) / Fs; % Time axis
    % figure;
    % plot(time, template, '-');
    % title("Multiphasic Template  of duration: "+ num2str(duration)+ " seconds");
    % xlabel('Time [s]');
end
