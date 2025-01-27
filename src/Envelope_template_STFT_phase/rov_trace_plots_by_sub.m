function rov_trace_plots_by_sub(data, env_data, fc, plot_type, sg_title, figure_path)
% ROV_TRACE_PLOTS_BY_SUB - Generate and save plots of signal traces and envelopes
%
% This function iterates through signal data organized by maps (A, B, C) and subjects,
% producing and saving plots of the signal traces and their corresponding envelopes or
% spectrograms based on the specified plot type.
%
% INPUTS:
%   data        - Struct containing signal data, organized by maps and subjects.
%   env_data    - Struct containing envelope data, organized similarly to `data`.
%   fc          - Sampling frequency in Hz.
%   plot_type   - Type of plot to generate ('envelope_or_cross' or 'STFT').
%   sg_title    - String for the subplot group title.
%   figure_path - Path to save the generated plots.
%
% OUTPUTS:
%   No explicit outputs; saves plots to the specified directory.

% Define plot types (currently supports only single_record for saving)
type_plots = ["single_record"];

% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i; % Construct map field name
    subjects = fieldnames(data.(map)); % Extract subject names for the current map

    % Loop through each subject in the map
    for j = 1:length(subjects)
        sub = subjects{j}; % Current subject identifier

        % Determine the number of records for the current subject
        [~, N] = size(data.(map).(sub).rov_trace);

        % Loop through each record for the subject
        for h = 1:N
            % Extract signal and envelope for the current record
            signal = data.(map).(sub).rov_trace{:, h};
            envelope = env_data.(map).(sub).rov_trace{:, h};

            % Define time axis for the signal
            x = [0:1/fc:1-1/fc]';

            % Parse the subject number from the subject identifier
            sub_num = split(sub, '_');
            sub_num = split(sub_num{2}, i);
            sub_num = sub_num{end};

            % Create a new figure and maximize its window
            fig = figure(1);
            fig.WindowState = "maximized";

            % Define plot title
            title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num + ...
                         ' trace, record: ' + num2str(h);
            full_title = {string(sg_title); string(title_plot)};

            % Generate the plot based on the specified plot type
            switch plot_type
                case "envelope_or_cross"
                    % Plot signal and envelope
                    plot(x, signal, "LineWidth", 0.8, "Color", "#4DBEEE");
                    hold on;
                    plot(x, envelope, "LineWidth", 1.5, "Color", "#0072BD");

                    % Set plot limits dynamically based on signal values
                    xlim([0, x(end)]);
                    ylim([min([min(signal, [], "omitnan"), min(envelope, [], "omitnan")]) ...
                          - 0.2 * abs(min([min(signal, [], "omitnan"), min(envelope, [], "omitnan")])), ...
                          max([max(signal, [], "omitnan"), max(envelope, [], "omitnan")]) ...
                          + 0.2 * abs(max([max(signal, [], "omitnan"), max(envelope, [], "omitnan")]))]);

                    % Add labels and title
                    xlabel('Time [s]');
                    ylabel('Voltage [mV]');
                    title(full_title, "FontSize", 14);

                case "STFT"
                    % Generate spectrogram
                    n = length(signal); % Signal length
                    t_signal = [0:1/fc:(n-1)/fc]'; % Signal time axis

                    % Define STFT parameters
                    win_length = 64; % Window length in points
                    hop_size = round(win_length / 3); % Hop size with 30% overlap
                    window = hamming(win_length, 'periodic'); % Hamming window
                    nfft = 1048; % Number of FFT points

                    % Plot spectrogram
                    ax1 = subplot(3, 3, 1:6); % Upper section for spectrogram
                    [S, F, T, P] = spectrogram(signal, window, hop_size, nfft, fc);
                    imagesc(T, F, 10 * log10(P));
                    axis tight;
                    set(gca, 'YDir', 'normal'); % Flip Y-axis to normal orientation
                    title(full_title, "FontSize", 14);
                    xlabel('Time [s]');
                    ylabel('Frequency [Hz]');
                    ylim([0, 400]); % Limit frequency range to 0-400 Hz
                    hColorbar = colorbar('southoutside'); % Add colorbar below plot
                    ylabel(hColorbar, 'Power/Frequency [dB/Hz]');

                    % Plot original signal in lower section
                    subplot(3, 3, 7:9);
                    plot(t_signal, signal, 'b');
                    title('Original Signal');
                    xlabel('Time [s]');
                    ylabel('Amplitude [mV]');
                    grid on;

                    % Link axes for synchronized zooming/panning
                    linkaxes(findall(gcf, 'Type', 'axes'), 'x');
            end

            % Save the plot with a descriptive filename
            file_name = "MAP_" + i + "_sub_" + sub_num + '_record_' + num2str(h) + '_';
            save_plot(file_name, type_plots(1), figure_path, fig, true);
        end
    end
end
end
