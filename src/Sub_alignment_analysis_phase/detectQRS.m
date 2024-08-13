function QRS_positions = detectQRS(signal, Fc)
    % detectQRS - Detects QRS complexes in the input ECG signal using the
    % Pan-Tompkins algorithm.
    %
    % Inputs:
    %    signal - Input ECG signal (a numeric array)
    %    Fc - Sampling frequency (Hz)
    %
    % Outputs:
    %    QRS_positions - Indices of detected QRS complexes in the signal

    % Preprocessing: Bandpass filter (5-15 Hz)
    [b, a] = butter(1, [5 15] / (Fc/2), 'bandpass');
    filteredSignal = filtfilt(b, a, signal);
    
    % Differentiation
    diffSignal = diff(filteredSignal);
    
    % Squaring
    squaredSignal = diffSignal .^ 2;
    
    % Moving window integration (MWI)
    windowSize = round(0.15 * Fc); % 150ms window
    integratedSignal = movmean(squaredSignal, windowSize);
    
    % Dynamic Thresholding
    maxIntegratedSignal = max(integratedSignal);
    if maxIntegratedSignal > 0
        threshold = 0.6 * maxIntegratedSignal;
    else
        threshold = 0; % Avoid invalid threshold when max is 0
    end
    
    % Thresholding and peak detection
    [~, QRS_positions] = findpeaks(integratedSignal, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.6 * Fc));
    
end
