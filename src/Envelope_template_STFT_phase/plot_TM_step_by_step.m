function plot_TM_step_by_step(signal, template, fs)
    % PLOT_TM_STEP_BY_STEP Visualizes step-by-step the template matching process.
    %
    % INPUTS:
    %   signal   - Pre-processed signal (vector)
    %   template - Template used for matching (vector)
    %   fs       - Sampling frequency

    % Normalize signal and template
    signal = signal / max(abs(signal));
    template = template / max(abs(template));

    % Time vector
    t = (0:length(signal)-1) / fs;

    % Invert template for cross-correlation via convolution
    flipped_template = flip(template);
    N_signal = length(signal);
    N_template = length(template);

    % Pre-allocate cross-correlation output
    corr_output = zeros(1, N_signal);

    % Prepare figure
    figure('Position', [100, 100, 1400, 400]);
    
    for idx = 1:N_signal
        % Compute one step of convolution (cross-correlation)
        for j = 1:N_template
            if idx - j + 1 > 0 && idx - j + 1 <= N_signal
                corr_output(idx) = corr_output(idx) + ...
                    signal(idx - j + 1) * flipped_template(j);
            end
        end

        % Normalize cross-correlation up to current index (for comparability)
        if idx >= N_template
            norm_corr = corr_output(1:idx - N_template + 1);
            norm_corr = norm_corr / max(abs(norm_corr + eps));  % Avoid division by zero
        end

        % Plot
        clf;
        hold on;
        % Plot original signal (light blue, dashed)
        plot(t, signal, 'Color', [0.4 0.6 1], 'LineStyle', '--', 'LineWidth', 1.5);

        % Overlay template at current position
        if idx >= N_template
            template_start = idx - N_template + 1;
            plot(t(template_start:idx), flipped_template, 'r', 'LineWidth', 2);
        elseif idx > 0
            plot(t(1:idx), flipped_template(end - idx + 1:end), 'r', 'LineWidth', 2);
        end

        % Plot normalized cross-correlation output
        if idx >= N_template
            plot(t(1:idx - N_template + 1), norm_corr, 'b', 'LineWidth', 1.5);
        end

        % Aesthetics
        title('Template Matching Step by Step', 'FontSize', 18);
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Amplitude (Normalized)', 'FontSize', 14);
        legend({'Original Signal', 'Template', 'Normalized Cross-Correlation'}, 'FontSize', 12);
        ylim([-1.1, 1.1]);  % Normalized signals
        xlim([0, t(end)]);
        grid on;
        hold off;
        
        drawnow limitrate;  % Efficient rendering
    end
end
