function [N_positive_corr_peaks, signal_corr_active_area] = analyse_TM_into_active_areas(record_id, data, env_dataset, T, fc, area)
% analyse_TM_into_active_areas - Analyzes the signal in the context of template matching (TM)
%                                 for detecting and quantifying active areas of interest in a given 
%                                 electrophysiological signal (e.g., atrial or ventricular regions).
%
% Syntax:
%   [N_positive_corr_peaks, signal_corr_active_area] = analyse_TM_into_active_areas(record_id, data, env_dataset, T, fc, area)
%
% Input Arguments:
%   record_id   - A vector containing the record identification information, where:
%                 - record_id(1) is the map identifier (e.g., 'MAP_A'),
%                 - record_id(2) is the subject identifier (e.g., '1'),
%                 - record_id(3) is the trace index (e.g., 1).
%   data        - A struct containing the raw signal data (e.g., 'rov_trace').
%   env_dataset - A struct containing the envelope of the signal (for detecting active areas).
%   T           - Duration of the template signal in seconds.
%   fc          - The sampling frequency of the signal in Hz.
%   area        - A string specifying the phase of interest ('atrial' or 'ventricular').
%
% Output Arguments:
%   N_positive_corr_peaks - The number of positive correlation peaks found in the active area.
%   signal_corr_active_area - The cross-correlation signal over the detected active phase.
%
% Description:
%   This function performs template matching (TM) analysis on a given signal, identifying areas of interest
%   (such as atrial or ventricular phases) within the signal based on its envelope. A biphasic sinusoidal
%   template is used for convolution with the signal, and a series of steps, including cross-correlation, 
%   differentiation, and thresholding, are applied to detect and quantify the active areas.
%
%   The procedure includes:
%     1. Extracting the signal and its envelope based on the record identifier.
%     2. Identifying the start and end times of the selected phase (atrial or ventricular).
%     3. Normalizing the signal and applying a smoothing filter.
%     4. Convolving the signal with a biphasic sinusoidal template to compute the cross-correlation.
%     5. Performing a differentiation of the correlation signal to highlight active regions.
%     6. Applying thresholding to create a map of active areas, and cleaning the map by removing invalid runs.
%     7. Counting the number of positive peaks in the resulting active area map.
%
%   If no valid active phase is detected (i.e., no valid start or end times), the function will return NaN for
%   both output variables.

% 0. Data extraction and envelope active areas
map = "MAP_" + record_id(1);
sub = map + num2str(record_id(2));
h = double(record_id(3));
signal = data.(map).(sub).rov_trace{:, h};
example_env = env_dataset.(map).(sub).rov_trace{:, h};

% Identifying areas of interest (atrial or ventricular)
[start_end_areas] = find_atrial_ventricular_areas(signal, example_env, fc);

if area == "atrial"
    idx_r = 1;  % Index for atrial phase
else
    idx_r = 2;  % Index for ventricular phase
end

t_start = start_end_areas(idx_r, 1);
t_end = start_end_areas(idx_r, 2);

% Phase detection check
phase_presence = true;
if isnan(t_start) || isnan(t_end)
    phase_presence = false;
    disp("No " + area + " phase detected for " + sub + "-" + num2str(h));
else
    example_corr = nan(length(signal), 1);
    % 1. Define the biphasic template
    N = round(T * fc);  % Number of samples in the template
    t_template = linspace(0, T, N);
    signal_example = signal(t_start:t_end);
    norm_signal = sqrt(sum(signal_example.^2));
    signal_example = signal_example / norm_signal;
    signal_example = movmean(signal_example, 50);  % Apply moving average for smoothing
    
    % Biphasic sinusoidal template definition
    template = sin(2 * pi * 1 / T * t_template);
    norm_template = sqrt(sum(template.^2));
    template = template / norm_template;
    
    % 2. Compute cross-correlation via convolution
    corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)
    example_corr(t_start:t_end) = movmean(corr, 50);  % Smoothed cross-correlation
    
    % 3. Derivation of cross-correlation for peak detection
    example_corr = movmean(example_corr, 70);
    d_corr = diff(example_corr);
    d_corr = [d_corr; nan];  % Ensure same length
    d_corr = movmean(d_corr, 100);  % Smoothing
    
    % 4. Map thresholding and cleaning
    d_corr = d_corr - mean(d_corr, "omitnan");
    mult_factor = 0.1;
    th_upper = abs(max(d_corr, [], "omitnan")) * mult_factor;
    th_lower = min(d_corr, [], "omitnan") * mult_factor;
    
    map_upper = d_corr > th_upper;
    map_lower = d_corr < th_lower;
    
    % 5. Cleaning the map by removing invalid runs
    % Remove unpaired runs in map_upper and map_lower
    [map_upper, map_lower] = clean_active_area_map(map_upper, map_lower);
end

% 6. Count the number of positive peaks in the active phase
if phase_presence
    N_positive_corr_peaks = numel(regionprops(map_upper, 'PixelIdxList'));  % Counting peaks
    signal_corr_active_area = example_corr;
else
    N_positive_corr_peaks = nan;
    signal_corr_active_area = nan;
end
