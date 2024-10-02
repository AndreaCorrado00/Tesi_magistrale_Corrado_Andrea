function x_denoised = denoise_ecg_wavelet(x, Fc, type, nLevels)
    % This function denoises an ECG signal using wavelet transform and a band-pass filter.
    % INPUTS:
    %   x        - The raw ECG signal.
    %   Fc       - The sampling frequency of the ECG signal.
    %   type     - The type of wavelet to be used for decomposition (e.g., 'db4').
    %   nLevels  - The number of decomposition levels for the wavelet transform.
    % OUTPUT:
    %   x_denoised - The denoised ECG signal after wavelet thresholding and filtering.

    waveletType = type;
    decompositionLevel = nLevels;

    % Check if the signal length supports the proposed number of decomposition levels
    signalLength = length(x);
    maxDecompositionLevel = wmaxlev(signalLength, waveletType);

    if decompositionLevel > maxDecompositionLevel
        decompositionLevel = maxDecompositionLevel;
        warning(['Level is reduced to ' num2str(decompositionLevel) ' to adapt better to the signal length']);
    end

    % Padding the signal (if needed) to ensure proper wavelet decomposition
    x_padded = x; 

    % Perform the Discrete Wavelet Transform (DWT)
    [C, L] = wavedec(x_padded, decompositionLevel, waveletType);

    % Donoho's thresholding for noise reduction
    sigma = median(abs(C)) / 0.6745; % Estimate noise standard deviation
    threshold = sigma * sqrt(2 * log(length(x_padded))); % Universal threshold

    % Apply soft thresholding to wavelet coefficients
    for i = 1:decompositionLevel
        C(L(i)+1:L(i+1)) = wthresh(C(L(i)+1:L(i+1)), 's', threshold);
    end

    % Reconstruct the denoised signal using inverse DWT
    x_denoised_padded = waverec(C, L, waveletType);

    % Remove the padding and return the original signal length
    x_denoised = x_denoised_padded(1:signalLength);

    % Apply high-pass filter to remove low-frequency noise
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x_denoised);

    % Apply low-pass filter to remove high-frequency noise
    [b, a] = butter(6, 60 / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);
end
