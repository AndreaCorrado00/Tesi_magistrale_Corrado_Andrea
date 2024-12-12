function [Pr20,Pr40,Pr60,Pr80,Pr100,Pr120,Pr140,Pr160,Pr180,Pr200,...
    Pr220,Pr240,Pr260,Pr280,Pr300,Pr320,...
    mnf,pkf,mnp,psr] = compute_PSD_features(signal,fs)

% Step 1: Compute the Power Spectral Density (PSD) using periodogram
[pxx, f] = periodogram(signal-mean(signal,"omitnan"), [], [], fs);  

% Step 2: Compute the total power up to 320 Hz
max_freq = 320;  % Maximum frequency for total power computation
total_power = trapz(f(f <= max_freq), pxx(f <= max_freq));

% Step 3: Compute the relative power in each 20 Hz sub-band
sub_band_width = 20;  % Sub-band width in Hz
num_bands = floor(max_freq / sub_band_width);  % Number of sub-bands (up to 320 Hz)
relative_power = zeros(1, num_bands);

for i = 1:num_bands
    band_start = (i - 1) * sub_band_width;
    band_end = i * sub_band_width;
    
    % Power in the current sub-band
    band_power = trapz(f(f >= band_start & f < band_end), pxx(f >= band_start & f < band_end)); % trapezoid as approximation of integration
    
    % Relative power
    relative_power(i) = (band_power / total_power);
end

% Assign relative powers to individual outputs
Pr20 = relative_power(1);
Pr40 = relative_power(2);
Pr60 = relative_power(3);
Pr80 = relative_power(4);
Pr100 = relative_power(5);
Pr120 = relative_power(6);
Pr140 = relative_power(7);
Pr160 = relative_power(8);
Pr180 = relative_power(9);
Pr200 = relative_power(10);
Pr220 = relative_power(11);
Pr240 = relative_power(12);
Pr260 = relative_power(13);
Pr280 = relative_power(14);
Pr300 = relative_power(15);
Pr320 = relative_power(16);

% Step 4: Frequency-domain features

% 4.1: Mean Frequency (MNF)
mnf = trapz(f .* pxx) / trapz(pxx);

% 4.2: Peak Frequency (PKF)
[~, pkf_index] = max(pxx);
pkf = f(pkf_index);

% 4.3: Mean Spectral Power (MNP)
mnp = trapz(f(f <= max_freq), pxx(f <= max_freq)) / max_freq;

% 4.4: Power Spectrum Ratio (PSR) around the PKF
delta_f = 10;  % Frequency window around PKF for PSR
psr_band = f >= (pkf - delta_f) & f <= (pkf + delta_f);
psr = trapz(f(psr_band), pxx(psr_band)) / total_power;

end
