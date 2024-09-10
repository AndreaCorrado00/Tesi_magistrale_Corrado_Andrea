function x_denoised = denoise_ecg_BP(x,Fc)

    
    % High pass filter
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x);

    % Low pass filter
    [b, a] = butter(8, 40 / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);


end