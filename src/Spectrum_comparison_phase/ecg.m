% This function generates a synthetic ECG signal with a specified length (L).
% The signal is constructed by linearly interpolating between predefined amplitude
% and duration points that mimic the general shape of an ECG waveform.
%
% Inputs:
%   L - The desired length of the ECG signal (number of samples).
%
% Outputs:
%   x - A 1-D array representing the synthetic ECG signal of length L.
%
% Additional Details:
% - The amplitude and duration points are predefined in arrays `a0` and `d0`.
% - Amplitudes are normalized to ensure the maximum amplitude is 1.
% - Durations are scaled proportionally to fit the specified signal length L.
% - Linear interpolation is used between adjacent points to form the waveform.

function x = ecg(L)
    % Define amplitude and duration points for the ECG waveform
    a0 = [0,  1, 40,  1,   0, -34, 118, -99,   0,   2,  21,   2,   0,   0,   0];
    d0 = [0, 27, 59, 91, 131, 141, 163, 185, 195, 275, 307, 339, 357, 390, 440];
    
    % Normalize amplitudes to have a maximum value of 1
    a = a0 / max(a0);
    
    % Scale durations to fit the desired signal length L
    d = round(d0 * L / d0(15));
    d(15) = L; % Ensure the final duration matches the signal length
    
    % Initialize the output signal
    x = zeros(1, L);
    
    % Generate the ECG signal by linear interpolation
    for i = 1:14
        % Define the range for the current segment
        m = d(i) : d(i+1) - 1;
        
        % Calculate the slope for linear interpolation
        slope = (a(i+1) - a(i)) / (d(i+1) - d(i));
        
        % Generate the values for the current segment
        x(m+1) = a(i) + slope * (m - d(i)); %#ok<AGROW> 
    end
end
