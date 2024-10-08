function show_filter_pipeline(type)
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")
switch type
    case "high_frequency_ecg"
        disp('Simulation of Spectrum evaluation pipeline on a signal with High Frequency Noise')
        ecg = ecg_simulation.high_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum
    case "Low_frequency_ecg"
        disp('Simulation of Spectrum evaluation pipeline on a signal with Low Frequency Noise')
        ecg = ecg_simulation.low_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum
end

%% Starting of simulation
x_original = ecg - mean(ecg); % Subtract the mean
N_original = length(x_original);
disp( ' ')

n_subs = round(N_original / step);
n_cols = ceil(sqrt(n_subs)); 
n_rows = ceil(n_subs / n_cols); 


% 
for i = step:step:N_original


end