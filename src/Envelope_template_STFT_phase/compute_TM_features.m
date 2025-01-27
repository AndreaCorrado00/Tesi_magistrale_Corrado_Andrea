function [cross_peak_1, cross_peak_pos_1, corr_energy_1, ...
          cross_peak_2, cross_peak_pos_2, corr_energy_2] = compute_TM_features(record_id, data, env_dataset, ...
                                                                                 cross_example_TM_1, cross_example_TM_2, ...
                                                                                 T, fc)
% compute_TM_features - Computes various features based on the cross-correlation
%                       of two templates (cross_example_TM_1 and cross_example_TM_2).
%
% Syntax:
%   [cross_peak_1, cross_peak_pos_1, corr_energy_1, cross_peak_2, cross_peak_pos_2, corr_energy_2] = 
%       compute_TM_features(record_id, data, env_dataset, cross_example_TM_1, cross_example_TM_2, T, fc)
%
% Input Arguments:
%   record_id         - Identifier for the data record.
%   data              - Data structure containing the signal data.
%   env_dataset       - Dataset containing the envelope data for template matching.
%   cross_example_TM_1 - Cross-correlation result using Template 1.
%   cross_example_TM_2 - Cross-correlation result using Template 2.
%   T                 - Duration of the template.
%   fc                - Sampling frequency of the signal in Hz.
%
% Output Arguments:
%   cross_peak_1      - Peak value of the cross-correlation signal for Template 1.
%   cross_peak_pos_1  - Position (time) of the peak for Template 1 (in seconds).
%   corr_energy_1     - Energy of the cross-correlation signal for Template 1.
%   cross_peak_2      - Peak value of the cross-correlation signal for Template 2.
%   cross_peak_pos_2  - Position (time) of the peak for Template 2 (in seconds).
%   corr_energy_2     - Energy of the cross-correlation signal for Template 2.
%
% Description:
%   This function computes various features from the cross-correlation signals
%   of two different templates (`cross_example_TM_1` and `cross_example_TM_2`). The features
%   computed for each template include:
%   1. The peak value of the cross-correlation signal.
%   2. The position (in seconds) of the peak within a specific time window (17% to 60% of the signal length).
%   3. The energy of the cross-correlation signal, normalized by the length of the non-NaN portion of the signal.
%
% Steps:
%   1. For each template's cross-correlation signal, the peak value and its position are identified within a time window.
%   2. The energy of the cross-correlation signal is calculated as the sum of the squared values, normalized by the length
%      of the non-NaN portion of the signal.
%
% Example:
%   [cross_peak_1, cross_peak_pos_1, corr_energy_1, cross_peak_2, cross_peak_pos_2, corr_energy_2] = 
%       compute_TM_features(record_id, data, env_dataset, cross_example_TM_1, cross_example_TM_2, T, fc);

%% Features of the whole cross-correlation signal: Template 1
% Defining the analysis window (from 17% to 60% of the signal length)
start_idx = round(fc * 0.17);
end_idx = round(fc * 0.6);

% Find the peak value and its position in the cross-correlation signal for Template 1
[cross_peak_1, cross_peak_pos_1] = max(cross_example_TM_1(start_idx:end_idx), [], 'omitmissing');
cross_peak_pos_1 = (cross_peak_pos_1 + start_idx) / fc;  % Convert index to time (in seconds)

% Compute the energy of the cross-correlation signal for Template 1
M = find(~isnan(cross_example_TM_1), 1, 'last') - find(~isnan(cross_example_TM_1), 1, 'first');
corr_energy_1 = sum(cross_example_TM_1.^2, 'omitnan') / M;

%% Features of the whole cross-correlation signal: Template 2
% Defining the analysis window (from 17% to 60% of the signal length)
start_idx = round(fc * 0.17);
end_idx = round(fc * 0.6);

% Find the peak value and its position in the cross-correlation signal for Template 2
[cross_peak_2, cross_peak_pos_2] = max(cross_example_TM_2(start_idx:end_idx), [], 'omitmissing');
cross_peak_pos_2 = (cross_peak_pos_2 + start_idx) / fc;  % Convert index to time (in seconds)

% Compute the energy of the cross-correlation signal for Template 2
M = find(~isnan(cross_example_TM_2), 1, 'last') - find(~isnan(cross_example_TM_2), 1, 'first');
corr_energy_2 = sum(cross_example_TM_2.^2, 'omitnan') / M;

end
