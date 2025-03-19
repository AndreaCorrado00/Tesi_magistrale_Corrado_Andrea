function show_envelope_slope_analysis(data, env_data, fc, record_id, saving_plot, figure_path, split_plots)
% This function performs envelope slope analysis on a given signal.
% It calculates the derivative of the envelope, applies thresholds,
% and identifies time thresholds for significant events in the signal.
%
% Parameters:
% data          - Struct containing raw signals
% env_data      - Struct containing envelope data of the signals
% fc            - Sampling frequency of the signal
% record_id     - Identifier for the record [MAP type, subject number, channel]
% saving_plot   - Boolean indicating whether to save the generated plots
% figure_path   - Path where the plot should be saved

% Extract the specific signal and its envelope based on the provided record ID
map = "MAP_" + record_id(1);
sub = map + num2str(record_id(2));
h = double(record_id(3));
signal = data.(map).(sub).rov_trace{:, h};
example_env = env_data.(map).(sub).rov_trace{:, h};

% Generate the x-axis (time) vector based on the sampling frequency
x = [0:1/fc:1-1/fc]';
sub_num = split(sub, '_');
sub_num = split(sub_num{2}, record_id(1));
sub_num = sub_num{end};

% Configure the figure for display or saving
if saving_plot
    screenSize = get(0, 'ScreenSize');
    fig = figure('Visible', 'off'); % Create figure for saving without showing it
    fig.Position = [0, 0, screenSize(3), screenSize(4)];
else
    fig = figure; % Create figure for immediate display
    fig.WindowState = "maximized";
end

% Add a title to the entire figure
sgtitle(["Example of envelope slope analysis for: MAP " + record_id(1) + ...
    ", sub: " + sub_num + ", record: " + num2str(h)]);
%------------------- VISUALIZATION -------------------%

%------------------- FIGURE 1: Signal + Envelope Pos/Neg -------------------%
if split_plots
    fig1 = figure;
    fig1.Position = [100, 100, 1200, 600];
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.2, "Color", "#0072BD");
    plot(x, -example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.2, "Color", "#A2142F");
    title("Step 1: positive & negative envelope evaluation",'FontSize', 20);
    legend(["Signal", "Envelope (+)", "Envelope (-)"]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);
    % if saving_plot
    %     file_name = sub + '_record_' + num2str(h) + '_env_pos_neg';
    %     save_plot(file_name, "env_pos_neg", figure_path, fig1, true);
    % end
end

%------------------- COMMON COMPUTATIONS -------------------%

% Smooth envelope
example_env = movmean(example_env, 50);

% Derivative
d_env = diff(example_env);
d_env = [d_env; nan];
d_env = movmean(d_env, 100);
d_env(1:round(0.17*fc)) = nan;
d_env(round(0.6*fc):end) = nan;
d_env = d_env - mean(d_env, "omitnan");

% Thresholds
mult_factor = 0.002;
th_upper = abs(max(d_env, [], "omitnan")) * mult_factor;
th_lower = min(d_env, [], "omitnan") * mult_factor * 50;
map_upper = d_env > th_upper;
map_lower = d_env < th_lower;

% Map correction
[map_upper_corr, map_lower_corr] = merge_runs(map_upper, map_lower);

% time thresholds
time_th = define_time_th(map_upper_corr, map_lower_corr);
time_th = clean_time_thresholds(signal, time_th, fc, 2.75);
%------------------- VISUALIZATION -------------------%

if split_plots
    %% Step 1: Derivative plot (single figure)
    fig2 = figure;
    fig2.Position = [100, 100, 1200, 600];
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.5, "Color", "#0072BD");
    plot(x, d_env * max(signal, [], "omitnan") / max(d_env), "LineWidth", 1.5, "Color", "#7E2F8E");
    plot(x, th_upper * max(signal, [], "omitnan") / max(d_env) * ones(length(x), 1), "r", "LineWidth", 1);
    plot(x, th_lower * max(signal, [], "omitnan") / max(d_env) * ones(length(x), 1), "r", "LineWidth", 1);
    title('Step 2:Envelope derivative','FontSize', 20);
    legend(["Signal", "Envelope", "d_{env}/dt"]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);
    % if saving_plot
    %     file_name = sub + '_record_' + num2str(h) + '_step1';
    %     save_plot(file_name, "step1", figure_path, fig2, true);
    % end



    %% Step 3: Thresholding
    fig3 = figure;
    fig3.Position = [100, 100, 1200, 600];
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.5, "Color", "#0072BD");
    plot(x, map_upper_corr * min([1, 1 / max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F");
    plot(x, -map_lower_corr * abs(max([-1, 1 / min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E");
    title('Step 3: Derivative thresholding','FontSize', 20);
    legend(["Signal", "Envelope", "d_{env}/dt >0", "d_{env}/dt <0"]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);
    % if saving_plot
    %     file_name = sub + '_record_' + num2str(h) + '_step3';
    %     save_plot(file_name, "step3", figure_path, fig4, true);
    % end

    %% Step 3: Time threshold definition
    fig3 = figure;
    fig3.Position = [100, 100, 1200, 600];
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    for k = 1:size(time_th, 1)
        start_time = time_th(k, 1) / fc;
        end_time = time_th(k, 2) / fc;
        plot([start_time, start_time], ylim, '--', 'LineWidth', 1, 'Color', [0, 0.5, 0]);
        plot([end_time, end_time], ylim, '--', 'LineWidth', 1, 'Color', [0.5, 0, 0]);
    end
    title('Step 4: Time thresholds definition');
    xlabel('Time [s]');
    ylabel('Amplitude [mV]');
    title('Step 4: time thresholds definition','FontSize', 20);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);
    % if saving_plot
    %     file_name = sub + '_record_' + num2str(h) + '_step2';
    %     save_plot(file_name, "step2", figure_path, fig3, true);
    % end

else
    %% Step 1: Compute the derivative of the envelope
    % Smooth the envelope using a moving average
    example_env = movmean(example_env, 50);

    % Compute the derivative of the smoothed envelope
    d_env = diff(example_env);
    d_env = [d_env; nan]; % Pad with NaN to maintain vector length
    d_env = movmean(d_env, 100); % Further smooth the derivative

    % Remove edge effects by setting initial and final segments to NaN
    d_env(1:round(0.17*fc)) = nan;
    d_env(round(0.6*fc):end) = nan;

    % Normalize the derivative by subtracting the mean
    d_env = d_env - mean(d_env, "omitnan");

    % Define thresholds for derivative values
    mult_factor = 0.002;
    th_upper = abs(max(d_env, [], "omitnan")) * mult_factor;
    th_lower = min(d_env, [], "omitnan") * mult_factor * 50;

    % Plot the original signal, envelope, and derivative with thresholds
    subplot(2, 2, 1)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.5, "Color", "#0072BD");
    plot(x, d_env * max(signal, [], "omitnan") / max(d_env), "LineWidth", 1.5, "Color", "#7E2F8E");
    plot(x, th_upper * max(signal, [], "omitnan") / max(d_env) * ones(length(x), 1), "r", "LineWidth", 1);
    plot(x, th_lower * max(signal, [], "omitnan") / max(d_env) * ones(length(x), 1), "r", "LineWidth", 1);
    title('Step 1: Envelope derivative');
    legend(["Signal", "Envelope", "d_{env}/dt"]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);

    %% Step 2: Thresholding the derivative
    % Create binary maps for upper and lower threshold crossings
    map_upper = d_env > th_upper;
    map_lower = d_env < th_lower;

    % Plot the signal, envelope, and threshold maps
    subplot(2, 2, 2)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.5, "Color", "#0072BD");
    plot(x, map_upper * min([1, 1 / max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F");
    plot(x, -map_lower * abs(max([-1, 1 / min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E");
    title('Step 2: Derivative thresholding');
    legend(["Signal", "Envelope", "d_{env}/dt >0", "d_{env}/dt <0"]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Amplitude [mV]', 'FontSize', 14);

    %% Step 3: Correct the binary maps
    [map_upper, map_lower] = merge_runs(map_upper, map_lower);

    % Plot the corrected maps
    subplot(2, 2, 3)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    plot(x, example_env * max(signal, [], "omitnan") / max(example_env), "LineWidth", 1.5, "Color", "#0072BD");
    plot(x, map_upper * min([1, 1 / max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F");
    plot(x, -map_lower * abs(max([-1, 1 / min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E");
    title('Step 3: Map correction');
    legend(["Signal", "Envelope", "d_{env}/dt >0", "d_{env}/dt <0"]);
    xlabel('Time [s]');
    ylabel('Amplitude [mV]');

    %% Step 4: Define time thresholds
    % Identify significant time intervals
    time_th = define_time_th(map_upper, map_lower);
    time_th = clean_time_thresholds(signal, time_th, fc, 2.75);

    % Plot the signal with the identified time thresholds
    subplot(2, 2, 4)
    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
    hold on;
    for k = 1:size(time_th, 1)
        start_time = time_th(k, 1) / fc;
        end_time = time_th(k, 2) / fc;
        plot([start_time, start_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0, 0.5, 0]);
        plot([end_time, end_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0.5, 0, 0]);
    end
    title('Step 4: Time thresholds definition');
    xlabel('Time [s]');
    ylabel('Amplitude [mV]');

    %% Save the plot if required
    if saving_plot
        file_name = sub + '_record_' + num2str(h) + '_';
        save_plot(file_name, "example_analysis", figure_path, fig, true);
    end
end

