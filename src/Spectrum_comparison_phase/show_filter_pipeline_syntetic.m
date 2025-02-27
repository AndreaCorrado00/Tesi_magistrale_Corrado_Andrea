% Function: show_filter_pipeline_syntetic
% Description:
% This function simulates an ECG signal with synthetic noise, applies a denoising pipeline,
% and compares the performance of wavelet-based and bandpass filter-based denoising techniques.
% The function also computes the Signal-to-Noise Ratio (SNR) and Root Mean Square Error (RMSE)
% for each filtering method. It visualizes the noisy ECG, the filtered signals, and the statistical
% results (paired t-test between wavelet and bandpass RMSE). The function accepts a noise type parameter
% and generates corresponding noisy signals such as white noise or baseline drift.
%
% Parameters:
%   - noise_type: A string indicating the type of noise to add to the ECG signal.
%     Options: 'white_noise_stationary_var_fix', 'baseline_drift'.

function show_filter_pipeline_syntetic(noise_type)
%load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat") 

%% Building the ground truth
% ECG parameters
Fs = 1000;           % F sampling(Hz)
duration = 1;        % Duration (s)
t = 0:1/Fs:duration; 

% 30 seconds of Synthetic ECG
ecg_signal = ecg(length(t));

ecg_signal = repmat(ecg_signal, 1, 50);
ecg_signal = sgolayfilt(ecg_signal, 2, 31);
ecg_signal = ecg_signal - mean(ecg_signal);

N = length(ecg_signal);
Ts = 1 / Fs;
t = 0:Ts:Ts*N - Ts;

switch noise_type
    case "white_noise_stationary_var_fix"
        var_noise = 0.002;
        noise = sqrt(var_noise) * randn(1, N);
        noisy_ecg = ecg_signal + noise;

        noise_title = "White, Gaussian noise with variance " + num2str(var_noise);
    case "baseline_drift"
        % Frequencies of sinusoids
        f1 = 0.166;    % Frequency of first sinusoid (Hz)
        f2 = 0.332;    % Frequency of second sinusoid (Hz)

        % Amplitudes of sinusoids
        A1 = 0.1;      % Amplitude of first sinusoid
        A2 = 0.1;      % Amplitude of second sinusoid

        % Generate the sinusoids
        noise = A1 * sin(2 * pi * f1 * t) + A2 * sin(2 * pi * f2 * t) + sqrt(0.002) * randn(1, N);
        
        noisy_ecg = ecg_signal + noise;
        noise_title = "Baseline drift noise ";
end

figure(1)
subplot(311)
plot(t, ecg_signal)
xlim([0, t(end)])
title('Reference',"FontSize",16)
subplot(312)
plot(t, noise)
xlim([0, t(end)])
title(noise_title,"FontSize",16)
subplot(313)
plot(t, noisy_ecg)
xlim([0, t(end)])
title('Noisy reference',"FontSize",16)
xlabel('Time [s]',"FontSize",14)

%% Starting of simulation
N_original = length(noisy_ecg);
Ts = 1 / Fs;
t_original = 0:Ts:Ts*N_original - Ts;

N_points = [Fs:Fs:N_original];

RMSE_wavelet_vector = [];
RMSE_bp_vector = [];

% for each ECG (n° beats) length the proposed pipeline is evaluated
for i = 1:length(N_points)
    lim = N_points(i);

    ref_win = ecg_signal(lim-Fs+1:lim) - mean(ecg_signal(lim-Fs+1:lim));

    noise_win = noise(lim-Fs+1:lim) - mean(noise(lim-Fs+1:lim));

    x = noisy_ecg(lim-Fs+1:lim) - mean(noisy_ecg(lim-Fs+1:lim));

    N = length(x);
    t = t_original(lim-Fs+1:lim);

    x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, 2, 60);
    x_w = x_w - mean(x_w);
    x_bp = handable_denoise_ecg_BP(x, Fs, 2, 60);
    x_bp = x_bp - mean(x_bp);

    % SNR evaluation
    % Noise
    P_noise_original = sum(noise_win.^2);
    % Signal
    P_ref_win = sum(ref_win.^2);
    
    SNR_original = 10 * log10(P_ref_win / P_noise_original);

    % Goodness of filtering is evaluated with RMSE
    RMSE_wavelet = sqrt(sum((ref_win - x_w).^2) / N);
    RMSE_bp = sqrt(sum((ref_win - x_bp).^2) / N);

    % saving results,
    RMSE_bp_vector = [RMSE_bp_vector; RMSE_bp];
    RMSE_wavelet_vector = [RMSE_wavelet_vector; RMSE_wavelet];

    if lim/Fs == 1 || lim == N_points(end)
        figure(i+1)
        hold on
        sgtitle("Denoising pipeline, beat between " + num2str(t(1)) + " and " + num2str(t(end)) + " sec ")
        plot(t, x, "Color", [.5, .5, .5], "LineStyle", ":", "LineWidth", 0.5)
        plot(t, ref_win, "Color", [.3, .3, .3], "LineWidth", 0.7)
        plot(t, x_bp, "Color", [0.9290 0.6940 0.1250], "LineWidth", 0.9)
        plot(t, x_w, "Color", "#0072BD", "LineWidth", 0.9)
        xlabel('time [s]')
        ylabel('Amplitude [mV]')
        xlim([t(1), t(end)])

        % Add SNR values as annotations
        annotation('textbox', [0.85, 0.5, 0.1, 0.1], 'String', ...
            {['SNR Original: ', num2str(SNR_original, '%.2f'), ' dB'], ...
            ['RMSE Bandpass : ', num2str(RMSE_bp, '%.4f')], ...
            ['RMSE Wavelet: ', num2str(RMSE_wavelet, '%.4f')]}, ...
            'FitBoxToText', 'on', 'BackgroundColor', 'w', 'EdgeColor', 'k', 'FontSize', 10);
        hold off
        legend(["Noisy signal", "Ground truth", "BP digital", "Wavelet th + BP digital"], "Location", "bestoutside")
    end
end

% paired t-test on RMSE vectors: null=are the same
[h, p] = ttest(RMSE_wavelet_vector, RMSE_bp_vector);

fprintf(["Paired T-test result: \n"])
if h == 1
    fprintf("  - Wavelet RMSE and BP RMSE are \n significantly different with a p-value of: " + num2str(p))
else
    fprintf("  - Wavelet RMSE and BP RMSE are not \nsignificantly different with a p-value of: " + num2str(p))
end

% Boxplots of RMSE
figure(i+2)

subplot(121)
boxplot(RMSE_wavelet_vector)
title("RMSE wavelet + bandpass")
ylim([0.03, 0.06])
set(gca, 'Position', [0.1, 0.2, 0.35, 0.6]) % [x, y, width, height]

subplot(122)
boxplot(RMSE_bp_vector)
title("RMSE bandpass")
ylim([0.03, 0.06])
set(gca, 'Position', [0.6, 0.2, 0.35, 0.6]) % [x, y, width, height]

sgtitle(noise_title)

% Add textbox with t-test result
annotation_text = sprintf('Paired T-test result: \n');

if h == 1
    annotation_text = [annotation_text, sprintf('Wavelet RMSE and BP RMSE are significantly different \n  with a p-value of: %.4e \n', p)];
else
    annotation_text = [annotation_text, sprintf('Wavelet RMSE and BP RMSE are not significantly different \n  with a p-value of: %.4e \n', p)];
end

annotation('textbox', [0.4, 0.02, 0.3, 0.1], 'String', annotation_text, ...
           'FitBoxToText', 'on', 'BackgroundColor', 'y', 'EdgeColor', 'k', 'FontSize', 10);
