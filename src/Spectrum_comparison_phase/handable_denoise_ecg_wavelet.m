function x_denoised = handable_denoise_ecg_wavelet(x, Fc, type, nLevels, padding, BP_band_pass, BP_band_stop)
    % This function denoises an ECG signal using wavelet transform with optional padding and custom band-stop filtering.
    % INPUTS:
    %   x            - The raw ECG signal.
    %   Fc           - The sampling frequency of the ECG signal.
    %   type         - The type of wavelet for decomposition (e.g., 'db4').
    %   nLevels      - The number of wavelet decomposition levels.
    %   padding      - Boolean to decide whether to apply circular padding.
    %   BP_band_stop - The cutoff frequency for the low-pass filter.
    % OUTPUT:
    %   x_denoised   - The denoised ECG signal after wavelet thresholding and filtering.

    waveletType = type;
    decompositionLevel = nLevels;

  
    signalLength = length(x);
   % Circular padding if required
if padding
    N=3;
    % Mirror padding
    x_padded = [flip(x);x;flip(x)];
    
    % Calculate the start index of the central repetition
    idx_start = ((N - 1) / 2) * signalLength + 1;
    
    % Calculate the end index of the central repetition
    idx_end = idx_start + signalLength - 1;
    
else
    % No padding, so keep the original signal
    x_padded = x;
    idx_start = 1;                       % Start from the first element
    idx_end = signalLength;               % End at the last element
end


    % Check if the signal length supports the proposed decomposition level

    maxDecompositionLevel = wmaxlev(signalLength, waveletType);

    if decompositionLevel > maxDecompositionLevel
        decompositionLevel = maxDecompositionLevel;
        warning(['Level is reduced to ' num2str(decompositionLevel) ' to adapt better to the signal length']);
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

    % Apply high-pass filter to remove low-frequency noise
    [b, a] = butter(6, BP_band_pass / (Fc / 2), 'high');
    x_denoised_padded = filtfilt(b, a, x_denoised_padded);

    % Apply low-pass filter with customizable cutoff frequency
    [b, a] = butter(8, BP_band_stop / (Fc / 2), 'low');
    x_denoised_padded = filtfilt(b, a, x_denoised_padded);

    % Remove the padding and return the original signal length
    x_denoised = x_denoised_padded(idx_start:idx_end);

end
