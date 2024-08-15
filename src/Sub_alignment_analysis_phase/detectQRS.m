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
    
    % Thresholding and peak detection in the integrated signal
    [~, peakLocations] = findpeaks(integratedSignal, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.6 * Fc));
    
    % Initialize QRS_positions
    QRS_positions = zeros(1, length(peakLocations));
    
    % Find the exact position of the QRS complex in the original filtered signal
    for i = 1:length(peakLocations)
        % Define a window around the detected peak location
        searchWindow = max(1, peakLocations(i) - round(0.1 * Fc)) : min(length(filteredSignal), peakLocations(i) + round(0.1 * Fc));
        
        % Find the peak in the original filtered signal within this window
        [~, maxIdx] = max(filteredSignal(searchWindow));
        
        % Adjust index relative to the original signal
        QRS_positions(i) = searchWindow(1) + maxIdx - 1;
    end
end

