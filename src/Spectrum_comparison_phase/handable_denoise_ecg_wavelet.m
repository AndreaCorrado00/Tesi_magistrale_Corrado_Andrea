function x_denoised = handable_denoise_ecg_wavelet(x, Fc, type, nLevels, padding, BP_band_stop)
    % This function denoises an ECG signal using wavelet transform with optional padding and custom band-stop filtering.
    % INPUTS:
    %   x            - The raw ECG signal.
    %   Fc           - The sampling frequency of the ECG signal.
    %   type         - The type of wavelet for decomposition (e.g., 'db4').
    %   nLevels      - The number of wavelet decomposition levels.
    %   padding      - Boolean to decide whether to symmetrically pad the signal.
    %   BP_band_stop - The cutoff frequency for the low-pass filter.
    % OUTPUT:
    %   x_denoised   - The denoised ECG signal after wavelet thresholding and filtering.

    waveletType = type;
    decompositionLevel = nLevels;

    % Check if the signal length supports the proposed decomposition level
    signalLength = length(x);
    maxDecompositionLevel = wmaxlev(signalLength, waveletType);

    if decompositionLevel > maxDecompositionLevel
        decompositionLevel = maxDecompositionLevel;
        warning(['Level is reduced to ' num2str(decompositionLevel) ' to adapt better to the signal length']);
    end

    % Symmetric padding if required
    if padding
        pow2Length = 2^nextpow2(signalLength);
        if pow2Length > signalLength
            x_padded = wextend('1D', 'sym', x, pow2Length - signalLength);
        else
            x_padded = x;
        end
    else
        x_padded = x;
    end

    % Perform Discrete Wavelet Transform (DWT)
    [C, L] = wavedec(x_padded, decompositionLevel, waveletType);

    % Donoho thresholding for noise reduction
    sigma = median(abs(C)) / 0.6745; % Estimate noise standard deviation
    threshold = sigma * sqrt(2 * log(length(x_padded))); % Universal threshold

    % Apply soft thresholding
    for i = 1:decompositionLevel
        C(L(i)+1:L(i+1)) = wthresh(C(L(i)+1:L(i+1)), 's', threshold);
    end

    % Reconstruct the signal using inverse DWT
    x_denoised_padded = waverec(C, L, waveletType);

    % Remove the padding and return the original signal length
    x_denoised = x_denoised_padded(1:signalLength);

    % Apply high-pass filter to remove low-frequency noise
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x_denoised);

    % Apply low-pass filter with customizable cutoff frequency
    [b, a] = butter(8, BP_band_stop / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);
end
