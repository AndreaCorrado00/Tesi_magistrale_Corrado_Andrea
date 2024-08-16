function QRS_position = detectQRS(signal, Fc)
    % detectQRS - Detects the most prominent QRS complex in the input ECG signal
    % using the Pan-Tompkins algorithm.
    %
    % Inputs:
    %    signal - Input ECG signal (a numeric array)
    %    Fc - Sampling frequency (Hz)
    %
    % Outputs:
    %    QRS_position - Index of the detected QRS complex in the signal

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
    
    % Initialize variables to track the most prominent QRS
    maxAmplitude = -inf;
    QRS_position = NaN;  % Use NaN if no QRS is found
    
    % Find the most prominent QRS complex in the original filtered signal
    windowBefore = round(0.05 * Fc); % 200ms before the peak
    windowAfter = round(0.3 * Fc);  % 300ms after the peak
    
    for i = 1:length(peakLocations)
        % Define a window around the detected peak location
        searchWindow = max(1, peakLocations(i) - windowBefore) : min(length(filteredSignal), peakLocations(i) + windowAfter);
        
        % Find the peak in the original filtered signal within this window
        [peakValue, maxIdx] = max(filteredSignal(searchWindow));
        
        % Adjust index relative to the original signal
        currentQRSPosition = searchWindow(1) + maxIdx - 1;
        
        % Check if this QRS has a higher amplitude than the previous ones
        if peakValue > maxAmplitude
            maxAmplitude = peakValue;
            QRS_position = currentQRSPosition;
        end
    end
end




