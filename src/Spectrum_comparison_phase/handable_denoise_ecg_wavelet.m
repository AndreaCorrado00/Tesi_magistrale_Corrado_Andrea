function x_denoised = handable_denoise_ecg_wavelet(x,Fc,type, nLevels,padding,BP_band_stop)

    waveletType= type;
    decompositionLevel = nLevels; 

    % Checking if the signal length supports the proposed number of levels
    signalLength = length(x);
    maxDecompositionLevel = wmaxlev(signalLength, waveletType);

    if decompositionLevel > maxDecompositionLevel
        decompositionLevel = maxDecompositionLevel;
        warning(['Level is reduced to ' num2str(decompositionLevel) ' to adapt better to the signal length']);
    end

    if padding
        % Symmetric padding handling
        pow2Length = 2^nextpow2(signalLength);
        if pow2Length > signalLength
            % Strang, G., and T. Nguyen. Wavelets and Filter Banks. Wellesley, MA: Wellesley-Cambridge Press,
            x_padded = wextend('1D', 'sym', x, pow2Length - signalLength);
        else
            x_padded = x;
        end
    else
        x_padded=x;
    end
    %  DWT (Discrete Wavelet Transform)
    [C, L] = wavedec(x_padded, decompositionLevel, waveletType);

    % Donoho thresholding
    sigma = median(abs(C)) / 0.6745; % noise std estimation
    threshold = sigma * sqrt(2 * log(length(x_padded)));

    for i = 1:decompositionLevel
        C(L(i)+1:L(i+1)) = wthresh(C(L(i)+1:L(i+1)), 's', threshold);
    end

    % Recostruction
    x_denoised_padded = waverec(C, L, waveletType);

    % Padding removement
    x_denoised = x_denoised_padded(1:signalLength);

    % High pass filter
    [b, a] = butter(6, 1 / (Fc / 2), 'high');
    x_denoised = filtfilt(b, a, x_denoised);

    % Low pass filter
    [b, a] = butter(8, BP_band_stop / (Fc / 2), 'low');
    x_denoised = filtfilt(b, a, x_denoised);

end