function template = generate_multiphasic_template(Fs, duration, smoothing_window)
    % generate_multiphasic_template Generates a synthetic multiphasic signal with 
    % a positive peak, negative peak, and return to baseline, with smoothing applied 
    % to the edges.
    %
    % Input:
    %   Fs (numeric)        - Sampling frequency in Hz (samples per second).
    %   duration (numeric)  - Duration of the multiphasic signal in seconds.
    %   smoothing_window (numeric) - The size of the smoothing window (in samples) 
    %                               used to smooth the signal.
    %
    % Output:
    %   template (numeric array) - The generated multiphasic signal after smoothing.
    %
    % The function creates a signal that starts with a positive peak, transitions 
    % to a negative peak, followed by a second positive peak, and ends at baseline.
    % The transitions between the peaks are smoothed using a Gaussian filter to 
    % remove sharp transitions.

    % Calculate the number of samples based on the duration and sampling frequency
    % The total number of samples (N) is rounded to the nearest integer.
    N = round(duration * Fs);

    % Define the multiphasic structure:
    % Segment 1: Positive peak (from 0 to 0.5)
    x1 = linspace(0, 0.5, round(N / 4));  % Linear transition from 0 to 0.5

    % Segment 2: Negative peak (from 0.5 to -1)
    x2 = linspace(0.5, -1, round(N / 4)); % Linear transition from 0.5 to -1

    % Segment 3: Second positive peak (from -1 to 0.5)
    x3 = linspace(-1, 0.5, round(N / 4)); % Linear transition from -1 to 0.5

    % Segment 4: Return to baseline (from 0.5 to 0)
    x4 = linspace(0.5, 0, N - length(x1) - length(x2) - length(x3)); 
    % Linear transition from 0.5 back to 0, filling the remaining length

    % Combine all segments to create the multiphasic signal
    template = [x1, x2, x3, x4];

    % Apply Gaussian smoothing to the entire template to smooth transitions
    % The 'gaussian' method smooths the signal using a Gaussian filter with the
    % specified smoothing window size.
    template = smoothdata(template, 'gaussian', smoothing_window);

    % % Plotting is optional, but can be used to visualize the generated template:
    % time = (0:N-1) / Fs;  % Time axis for plotting
    % figure;
    % plot(time, template, '-',"LineWidth",1.2);  % Plot the signal
    % title("Multiphasic Template of duration: "+ num2str(duration)+ " seconds", "FontSize",16);
    % xlabel('Time [s]',"FontSize",16);
    % xlim([0, duration])  % Set the x-axis limit to the desired duration
end
