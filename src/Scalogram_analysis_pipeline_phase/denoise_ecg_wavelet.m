function x_denoised = denoise_ecg_wavelet(x, Fc, type, nLevels)
    % Function to denoise ECG signal using wavelet thresholding and filtering.
    %
    % INPUTS:
    %   x - ECG signal to be denoised
    %   Fc - Cutoff frequency for high-pass and low-pass filters
    %   type - Type of wavelet to use for denoising
    %   nLevels - Number of decomposition levels for wavelet transform
    %
    % OUTPUT:
    %   x_denoised - Denoised ECG signal

    waveletType = type;
    decompositionLevel = nLevels; 

    % Check if the signal length supports the proposed number of levels
    signalLength = length(x);
    maxDecompositionLevel = wmaxlev(signalLength, waveletType);

    if decompositionLevel > maxDecompositionLevel
        decompositionLevel = maxDecompositionLevel;
        warning(['Level is reduced to ' num2str(decompositionLevel) ' to adapt better to the signal length']);
    end

    % Perform Discrete Wavelet Transform (DWT)
    [C, L] = wavedec(x, decompositionLevel, waveletType);

    % Estimate noise and threshold
    sigma = median(abs(C)) / 0.6745;
    threshold = sigma * sqrt(2 * log(length(x)));

    for i = 1:decompositionLevel
        C(L(i)+1:L(i+1)) = wthresh(C(L(i)+1:L(i+1)), 's', threshold);
    end

    % Reconstruct the signal
    x_denoised_padded = waverec(C, L, waveletType);

    % Remove padding and apply filters
    x_denoised = x_denoised_padded(1:signalLength);

    % High-pass filter
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x_denoised);

    % Low-pass filter
    [b, a] = butter(8, 70 / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);
end
