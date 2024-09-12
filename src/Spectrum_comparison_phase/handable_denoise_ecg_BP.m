function x_denoised = handable_denoise_ecg_BP(x,Fc,BP_band_stop)

    
    % High pass filter
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x);

    % x_denoised=x;
    % Low pass filter
    [b, a] = butter(8, BP_band_stop / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);


end