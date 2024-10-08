function x_denoised = denoise_ecg_BP(x, Fc)
    % This function applies a band-pass filter to denoise an ECG signal.
    % INPUTS:
    %   x  - The raw ECG signal.
    %   Fc - The sampling frequency of the ECG signal.
    % OUTPUT:
    %   x_denoised - The denoised ECG signal after applying high-pass and low-pass filters.
    
    % High pass filter to remove baseline drift
    [b, a] = butter(6, 3 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x); % Apply zero-phase filtering to avoid phase distortion

    % Low pass filter to remove high-frequency noise
    [b, a] = butter(8, 70 / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised); % Apply zero-phase filtering again
end
