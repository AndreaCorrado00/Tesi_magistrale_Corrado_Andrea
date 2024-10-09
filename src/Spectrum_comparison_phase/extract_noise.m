function noise = extract_noise(low_band, high_band, Fs, x,plotting)
% EXTRACT_NOISE Extracts noise components from an ECG signal by applying a
% low-pass filter (0-3 Hz) and a high-pass filter (>60 Hz) using a Butterworth design.
%
% INPUTS:
%   low_band  - Low cutoff frequency for the low-pass filter (in Hz)
%   high_band - High cutoff frequency for the high-pass filter (in Hz)
%   Fs        - Sampling frequency (in Hz)
%   x         - Input ECG signal (vector)
%
% OUTPUT:
%   noise     - Output signal containing noise components (low-frequency and high-frequency noise)
%
% DESCRIPTION:
% This function takes an input ECG signal, applies a low-pass filter to
% extract the low-frequency noise (below 3 Hz) and a high-pass filter to 
% extract the high-frequency noise (above 60 Hz). The filtered components
% are then summed to obtain the overall noise component. The function 
% also plots the frequency responses of the two filters.

    % Remove DC component (mean) from the signal
    x = x - mean(x);
    N = length(x);   % Length of the input signal
    Ts = 1 / Fs;     % Sampling period

    %% Design the Butterworth filters
    % Low-pass filter for extracting the low-frequency noise (0-3 Hz)
    Wn_low = low_band / (Fs / 2);  % Normalize the low cutoff frequency
    [b_low, a_low] = butter(6, Wn_low, 'low');  % 6th-order Butterworth filter

    % High-pass filter for extracting the high-frequency noise (>60 Hz)
    Wn_high = high_band / (Fs / 2);  % Normalize the high cutoff frequency
    [b_high, a_high] = butter(6, Wn_high, 'high');  % 6th-order Butterworth filter

    %% Apply the filters to the input signal
    filtered_low = filtfilt(b_low, a_low, x);  % Zero-phase low-pass filtering
    filtered_high = filtfilt(b_high, a_high, x);  % Zero-phase high-pass filtering

    % Sum the low and high-frequency components to get the noise
    noise = filtered_low + filtered_high;

    %% Plot the frequency responses of the filters
    if plotting
        figure;

        % Frequency response of the low-pass filter
        [h_low, f_low] = freqz(b_low, a_low, N, Fs);
        plot(f_low, abs(h_low), 'b', 'LineWidth', 1.5);  % Plot low-pass filter response
        hold on;

        % Frequency response of the high-pass filter
        [h_high, f_high] = freqz(b_high, a_high, N, Fs);
        plot(f_high, abs(h_high), 'r', 'LineWidth', 1.5);  % Plot high-pass filter response

        % Configure the plot
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        title('Frequency Response of Low-pass and High-pass Filters');
        legend('Low-pass (0-3 Hz)', 'High-pass (>60 Hz)');
        grid on;
        hold off;
    end

end
