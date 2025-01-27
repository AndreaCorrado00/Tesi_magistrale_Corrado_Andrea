% This function evaluates the performance of AR (Auto-Regressive) models on
% different types of ECG signals. It uses Yule-Walker and Least Squares methods 
% to estimate AR model parameters and compares their performance with Welch's 
% method for spectrum estimation. The function also analyzes prediction errors 
% and their autocorrelation.
%
% Inputs:
%   type - A string specifying the ECG signal type. Accepted values are:
%          - "high_frequency_ecg": ECG with high-frequency noise.
%          - "Low_frequency_ecg": ECG with low-frequency noise.
%          - "PhysioNet_healthy": Healthy ECG from PhysioNet database.
%          - "PhysioNet_Pathological": Pathological ECG from PhysioNet database.
%
% Outputs:
%   The function generates plots that include:
%   - Prediction error over time.
%   - Autocorrelation of the prediction error.
%   - Spectrum estimates (AR Yule-Walker, AR Least Squares, and Welch methods).
%
% Notes:
% - The function assumes the presence of a .mat file containing the variable
%   `ecg_simulation` with fields corresponding to different ECG signal types.
% - For PhysioNet signals, a 10-second segment is extracted and scaled for analysis.
%
% Dependencies:
% - `denoise_ecg_wavelet`: A function for wavelet-based ECG denoising.
% - `stima_autocorr`: A function for computing autocorrelation of a signal.
% - `evaluate_order`: A function to evaluate AR model order.
%
% Example Usage:
%   show_AR_model_performance("high_frequency_ecg");
%
function show_AR_model_performance(type)
    % Load required ECG signal data
    load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat");
    
    % Define signal properties based on the input type
    switch type
        case "high_frequency_ecg"
            name = "ECG with HF noise";
            ecg = ecg_simulation.high_freq;
            Fs = 1000; % Sampling frequency in Hz
            step = 1000; % Increment of points for spectrum evaluation
        case "Low_frequency_ecg"
            name = "ECG with LF noise";
            ecg = ecg_simulation.low_freq;
            Fs = 1000; % Sampling frequency in Hz
            step = 1000; % Increment of points for spectrum evaluation
        case "PhysioNet_healthy"
            name = "Healthy ECG from PhysioNet";
            ecg = ecg_simulation.healthy;
            Fs = 360; % Sampling frequency in Hz
            step = 720; % Increment of points for spectrum evaluation
        case "PhysioNet_Pathological"
            name = "Pathological ECG from PhysioNet";
            ecg = ecg_simulation.patological;
            Fs = 360; % Sampling frequency in Hz
            step = 720; % Increment of points for spectrum evaluation
        otherwise
            error("Invalid ECG type specified.");
    end
    
    %% Signal preprocessing
    x_original = ecg - mean(ecg); % Remove DC offset
    if contains(type, "PhysioNet")
        x_original = x_original / 1000; % Scale PhysioNet signals
        t_start = 5; % Start time in seconds
        t_end = 15; % End time in seconds
        start_index = round(t_start * Fs) + 1;
        end_index = round(t_end * Fs);
        x_original = x_original(start_index:end_index); % Extract segment
    end
    
    %% Denoising using wavelet transformation
    x_w = denoise_ecg_wavelet(x_original, Fs, 'sym4', 9);
    x_w = x_w - mean(x_w); % Remove residual DC offset
    N = length(x_w);
    Ts = 1 / Fs;
    t = 0:Ts:(N - 1) * Ts; % Time vector
    
    %% AR model estimation (Yule-Walker)
    p = 100; % AR model order
    th = ar(x_w, p, 'yw');
    a_yw = th.a;
    
    %% Prediction error and autocorrelation
    err = filter(th.a, 1, x_w); % Prediction error
    tau_max = 100; % Maximum lag for autocorrelation
    Ry = stima_autocorr(err, tau_max); % Autocorrelation
    
    %% AR spectrum estimation (Yule-Walker)
    [H, f] = freqz(1, th.a, N, Fs); % Frequency response
    DSP = th.NoiseVariance * abs(H).^2; % Power spectral density
    
    %% AR spectrum estimation (Least Squares)
    p_ls = evaluate_order(x_w, 8, 14, 2, 6, 'ls');
    th_ls = ar(x_w - mean(x_w), p_ls, 'ls');
    [H_ls, f_ls] = freqz(1, th_ls.a, N, Fs);
    DSP_ls = th_ls.NoiseVariance * abs(H_ls).^2; % Power spectral density
    DSP_ls = max(DSP) / max(DSP_ls) * DSP_ls; % Normalize
    
    %% Welch spectrum estimation
    window = hamming(512);
    noverlap = length(window) / 2;
    nfft = 2048;
    [pxx, f_welch] = pwelch(x_w, window, noverlap, nfft, Fs);
    pxx = max(DSP) / max(pxx) * pxx; % Normalize
    
    %% Plot results
    figure(1);
    sgtitle("Prediction error and autocorrelation function: " + name);
    
    % Prediction error plot
    subplot(3, 1, 1);
    plot(t, err, 'b-');
    xlabel('Time [s]');
    ylabel('Prediction error [mV]');
    
    % Autocorrelation plot
    subplot(3, 1, 2);
    stem(0:tau_max, Ry, 'bo');
    title('Autocorrelation');
    xlabel('\tau');
    
    % Spectrum estimation plot
    subplot(3, 1, 3);
    hold on;
    plot(f_welch, pxx, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 0.5);
    plot(f, DSP, 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 1.5);
    plot(f_ls, DSP_ls, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
    hold off;
    ylabel('PSD');
    xlabel('Frequency [Hz]');
    xlim([0, 60]);
    legend('Welch', 'AR YW estimation', 'AR LS estimation');
end
