function [cross_peak,cross_peak_pos]=compute_TM_features(signal_example,T, fs)
% 1. Define the template (biphasic)
N = round(T * fs);  % Number of samples in the template
t_template = linspace(0, T, N);

amplitude = max(abs(signal_example));
template = amplitude* sin(2 * pi * 1/T * t_template); % Biphasic siusoid template
corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)
% Normalization factors
norm_signal = sqrt(sum(signal_example.^2));  % Norm of the signal
norm_template = sqrt(sum(template.^2));  % Norm of the template
corr = movmean(corr / (norm_signal * norm_template),50);

[cross_peak,cross_peak_pos]=max(corr,[],"omitmissing");

