function show_filter_pipeline_didactical(type)
% This function demonstrates the application of signal processing techniques 
% for denoising ECG signals. Depending on the selected 'type', it loads different 
% ECG signal datasets, applies pre-processing, and then evaluates the performance 
% of wavelet-based and bandpass filtering methods. The results are visualized 
% through plots showing the noisy signal and filtered signals over time.
%
% Parameters:
%   type (string): Specifies the type of ECG signal to process. Valid options are:
%       - "high_frequency_ecg": ECG signal with high-frequency noise.
%       - "Low_frequency_ecg": ECG signal with low-frequency noise.
%       - "PhysioNet_healthy": ECG signal from a healthy subject in the PhysioNet database.
%       - "PhysioNet_Pathological": ECG signal from a pathological subject in the PhysioNet database.
%
% This function loads the necessary ECG dataset, processes the signal based on 
% the selected type, and visualizes the results of different filtering techniques 
% (wavelet thresholding and bandpass filtering).

% Load ECG simulation data
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")

% Choose the dataset based on the input type
switch type
    case "high_frequency_ecg"
        name = "ECG with high frequency noise";
        ecg = ecg_simulation.high_freq;
        Fs = 1000; % Sampling frequency in Hz
        step = 1000; % Increment of points for spectrum evaluation
    case "Low_frequency_ecg"
        name = "ECG with low frequency noise";
        ecg = ecg_simulation.low_freq;
        Fs = 1000; % Sampling frequency in Hz
        step = 1000; % Increment of points for spectrum evaluation
    case "PhysioNet_healthy"
        name = "Healthy subject Physionet DB";
        ecg = ecg_simulation.healthy;
        Fs = 360; % Sampling frequency in Hz
        step = 720; % Increment of points for spectrum evaluation
    case "PhysioNet_Pathological"
        name = "Pathological subject Physionet DB";
        ecg = ecg_simulation.patological;
        Fs = 360; % Sampling frequency in Hz
        step = 720; % Increment of points for spectrum evaluation
end

% Signal preprocessing (remove mean)
x_original = ecg - mean(ecg); 

% If the signal is from the PhysioNet database, extract a segment of the signal
if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
    x_original = x_original / 1000; % Scale the signal

    t_start = 10; % Start time in seconds
    t_end = 20; % End time in seconds

    % Calculate indices corresponding to the start and end times
    start_index = round(t_start * Fs) + 1; % MATLAB indexing starts at 1
    end_index = round(t_end * Fs);

    % Extract the segment from the signal
    x_original = x_original(start_index:end_index);
end

N = length(x_original); % Length of the signal
Ts = 1 / Fs; % Sampling period
t = 0:Ts:Ts*N-Ts; % Time vector

% Define the points for evaluation
N_original = length(x_original);
N_points = [step, N_original];

% Process the ECG signal in segments and evaluate filtering methods
for i = 1:length(N_points)
    lim = N_points(i);

    % Extract a segment of the signal
    x = x_original(1:lim) - mean(x_original(1:lim));
   
    % Length of the segment
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;

    % Apply wavelet denoising
    x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, 2, 60);
    x_w = x_w - mean(x_w);

    % Apply bandpass denoising
    x_bp = handable_denoise_ecg_BP(x, Fs, 2, 60);
    x_bp = x_bp - mean(x_bp);

    % Plot the results
    figure(i+2)
    hold on
    sgtitle("Denoising pipeline, N° points: " + num2str(N_points(i)) + ", " + name)
    plot(t, x, "Color", [.5, .5, .5], "LineStyle", ":", "LineWidth", 0.5)
    plot(t, x_bp, "Color", "#0072BD", "LineWidth", 0.9)

    xlabel('Time [s]')
    ylabel('Amplitude [mV]')
    xlim([0, t(end)])

    hold off
    legend(["Noisy signal", "BP digital"], "Location", "bestoutside")
end
