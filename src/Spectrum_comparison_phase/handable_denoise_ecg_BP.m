function x_denoised = handable_denoise_ecg_BP(x, Fc, BP_band_stop)
    % This function denoises an ECG signal using a customizable band-stop filter.
    % INPUTS:
    %   x            - The raw ECG signal.
    %   Fc           - The sampling frequency of the ECG signal.
    %   BP_band_stop - The cutoff frequency for the low-pass filter.
    % OUTPUT:
    %   x_denoised   - The denoised ECG signal after applying high-pass and customizable low-pass filters.
    
    % High pass filter to remove baseline drift
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x);

    % Low pass filter with customizable cutoff frequency
    [b, a] = butter(8, BP_band_stop / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);
end
