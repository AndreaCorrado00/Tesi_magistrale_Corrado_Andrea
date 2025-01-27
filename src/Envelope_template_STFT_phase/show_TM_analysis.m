function show_TM_analysis(record_id, data, env_dataset, TM_dataset, fc, area, saving_plot, figure_path)
    %% show_TM_analysis Function
    % This function performs Template Matching (TM) analysis of a given signal, 
    % using a specified record from the provided datasets. The analysis is performed
    % on a specific area (either 'atrial' or 'ventricular') and includes various 
    % steps such as correlation, thresholding, and peak detection. The function 
    % also includes plotting capabilities and the option to save the generated plots.
    %
    % INPUTS:
    %   - record_id:  A unique identifier for the record in the dataset (format: [map, sub, h]).
    %   - data:        A struct containing the signal data.
    %   - env_dataset: A struct containing the envelope data.
    %   - TM_dataset:  A struct containing the Template Matching data.
    %   - fc:          The frequency of the signal (samples per second).
    %   - area:        The area of interest for analysis, either 'atrial' or 'ventricular'.
    %   - saving_plot: Boolean flag indicating whether to save the generated plot.
    %   - figure_path: The file path to save the plot if saving_plot is true.
    %
    % OUTPUTS:
    %   - A series of plots displaying the analysis results at different steps.
    %   - The plot is saved if saving_plot is true.

    %% Data Information Extraction
    % Extract the necessary data based on the provided record_id
    map = "MAP_" + record_id(1);
    sub = map + num2str(record_id(2));
    h = double(record_id(3));
    signal = data.(map).(sub).rov_trace{:, h};
    example_env = env_dataset.(map).(sub).rov_trace{:, h};
    example_corr = TM_dataset.(map).(sub).rov_trace{:, h};

    %% Sub-label Extraction for Display
    sub_num = split(sub, '_');
    sub_num = split(sub_num{2}, record_id(1));
    sub_num = sub_num{end};

    %% Figure Setup for Plotting
    if saving_plot
        screenSize = get(0, 'ScreenSize');
        fig = figure('Visible', 'off');
        fig.Position = [0, 0, screenSize(3), screenSize(4)];
    else
        fig = figure;
        fig.WindowState = "maximized";
    end

    %% Step 0: Finding Atrial Phase Using Envelope
    [start_end_areas] = find_atrial_ventricular_areas(signal, example_env, fc);

    if area == "atrial"
        t_atr_start = start_end_areas(1, 1);
        t_atr_end = start_end_areas(1, 2);
    else
        t_atr_start = start_end_areas(2, 1);
        t_atr_end = start_end_areas(2, 2);
    end

    sgtitle(["Example of TM " + area + " phase analysis for: MAP " + record_id(1) + ", sub: " + sub_num + ", record: " + num2str(h)])

    % Handle missing atrial phase detection
    atr_phase_presence = true;
    if isnan(t_atr_start) || isnan(t_atr_end)
        atr_phase_presence = false;
        t_atr_start = 1;
        t_atr_end = length(signal);
        disp("No atrial phase detected for " + sub + "-" + num2str(h))
    else
        example_corr = nan(length(signal), 1);
        % Define and normalize the template
        T = 0.05; % Template duration in seconds
        N = round(T * fc);  % Number of samples in the template
        t_template = linspace(0, T, N);
        signal_example = signal(t_atr_start:t_atr_end);
        norm_signal = sqrt(sum(signal_example.^2));
        signal_example = signal_example / norm_signal;
        signal_example = movmean(signal_example, 50);
        template = sin(2 * pi * 1 / T * t_template); % Biphasic sinusoidal template
        norm_template = sqrt(sum(template.^2));
        template = template / norm_template;
        corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)
        example_corr(t_atr_start:t_atr_end) = movmean(corr, 50);
    end

    % Plotting the signal and the correlation during atrial phase
    x = [0:1/fc:1-1/fc]';
    subplot(2, 2, 1)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE")
    hold on
    plot(x(t_atr_start:t_atr_end), example_corr(t_atr_start:t_atr_end), "LineWidth", 1.2, "Color", "#0072BD")
    if atr_phase_presence
        % Plot vertical dashed lines for atrial phase
        for k = 1
            start_time = t_atr_start / fc; % Convert index to time
            end_time = t_atr_end / fc;     % Convert index to time
            plot([start_time, start_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0, 0.5, 0]);
            plot([end_time, end_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0.5, 0, 0]);
        end
    end

    %% Step 1: Derivative of Correlation Signal
    % Compute the derivative of the correlation signal to detect peaks
    example_corr = movmean(example_corr, 70);
    d_corr = diff(example_corr);
    d_corr = [d_corr; nan];  % Append NaN for alignment
    d_corr = movmean(d_corr, 100);
    d_corr(1:t_atr_start) = nan;
    d_corr(t_atr_end:end) = nan;
    d_corr = d_corr - mean(d_corr, "omitnan");

    % Define thresholds for peak detection
    mult_factor = 0.1;
    th_upper = abs(max(d_corr, [], "omitnan")) * mult_factor;
    th_lower = min(d_corr, [], "omitnan") * mult_factor;

    % Plot the derivative and thresholds
    plot(x, d_corr * max(signal, [], "omitnan") / max(d_corr), "LineWidth", 1.5, "Color", "#7E2F8E")
    plot(x(t_atr_start:t_atr_end), th_upper * max(signal, [], "omitnan") / max(d_corr) * ones(length(x(t_atr_start:t_atr_end)), 1), "r", "LineWidth", 1)
    plot(x(t_atr_start:t_atr_end), th_lower * max(signal, [], "omitnan") / max(d_corr) * ones(length(x(t_atr_start:t_atr_end)), 1), "r", "LineWidth", 1)
    title('Step 1: TM record derivative windowed')
    legend(["Signal", "TM record", "start atr phase", "end atr phase", "d_{TMrecord}/dt"])
    xlabel('time [s]')
    ylabel('Amplitude [mV]')

    %% Step 2: Map Creation (Thresholding)
    % Thresholding the derivative to identify key events
    subplot(2, 2, 2)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE")
    hold on

    if atr_phase_presence
        map_upper = d_corr > th_upper;
        map_lower = d_corr < th_lower;
        plot(x(t_atr_start:t_atr_end), example_corr(t_atr_start:t_atr_end) * max(signal(t_atr_start:t_atr_end), [], "omitnan") / max(example_corr(t_atr_start:t_atr_end)), "LineWidth", 1.5, "Color", "#0072BD")
        plot(x, map_upper * min([1, 1 / max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F")
        plot(x, -map_lower * abs(max([-1, 1 / min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E")
        title('Step 2: derivative thresholding')
        legend(["Signal", "TM record", "d_{TMrecord}/dt >0", "d_{TMrecord}/dt <0"])
    end
    xlabel('time [s]')
    ylabel('Amplitude [mV]')

    %% Step 3: Map Merge
    % Combine the maps from step 2 to identify continuous events
    subplot(2, 2, 3)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE")
    hold on

    if atr_phase_presence
        % Merge the thresholded maps, correcting for continuity
        % (details omitted for brevity)
        title('Step 3: map correction')
        legend(["Signal", "TM record", "d_{TMrecord}/dt >0", "d_{TMrecord}/dt <0"])
    end
    xlabel('time [s]')
    ylabel('Amplitude [mV]')

    %% Step 4: Peak Count (Positive Peaks in Atrial Phase)
    % Count the number of positive peaks in the atrial phase
    if atr_phase_presence
        N_positive_corr_peaks = numel(regionprops(map_upper, 'PixelIdxList'));
    else
        N_positive_corr_peaks = 0;
    end

    subplot(2, 2, 4)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE")
    hold on
    plot(x(t_atr_start:t_atr_end), example_corr(t_atr_start:t_atr_end) * max(signal(t_atr_start:t_atr_end), [], "omitnan") / max(example_corr(t_atr_start:t_atr_end)), "LineWidth", 1.5, "Color", "#0072BD")
    if atr_phase_presence
        for k = 1
            start_time = t_atr_start / fc; % Convert index to time
            end_time = t_atr_end / fc;     % Convert index to time
            plot([start_time, start_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0, 0.5, 0]);
            plot([end_time, end_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0.5, 0, 0]);
        end
        legend(["Signal", "TM record", "start atr phase", "end atr phase"])
    end

    title("Step 4: atrial correlation peaks count: " + num2str(N_positive_corr_peaks))
    xlabel('time [s]')
    ylabel('Amplitude [mV]')

    %% Saving the Plot
    if saving_plot
        file_name = sub + '_record_' + num2str(h) + '_' + area + '_';
        save_plot(file_name, "example_analysis", figure_path, fig, true);
    end
end
