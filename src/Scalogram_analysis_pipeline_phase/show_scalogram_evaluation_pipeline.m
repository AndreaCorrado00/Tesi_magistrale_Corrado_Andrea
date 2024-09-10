function show_scalogram_evaluation_pipeline(type)
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")

disp('This code shows a proposed pipeline to obtain ECG spectra:')
disp('   1. Filter the signal with wavelet thresholding and numerical filters')
disp('   2. Find the best AR order, which ensures the highest similarity between AR spectrum and Welch one')
disp('   3. Evaluate the spectrum')

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

    case "PhysioNet_healthy"
        disp('Simulation of Spectrum evaluation pipeline on a signal from PhysioNet DB of a healthy subject')
        ecg = ecg_simulation.healthy;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
    case "PhysioNet_Pathological"
        disp('Simulation of Spectrum evaluation pipeline on a signal from PhysioNet DB of a pathological subject')
        ecg = ecg_simulation.patological;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
end

%% Starting of simulation
x_original = ecg - mean(ecg); % Subtract the mean
N_original = length(x_original);
disp( ' ')
%pause(2)
disp('----PREPROCESSING----')
disp('0. Signal is processed by eliminating the mean')
if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
    %% Signal reduction (avoid artifacts)
    disp('      Moreover, in this case, the signal is windowed to avoid artifacts')
    x_original = x_original / 1000;

    t_start = 5; % Start time in seconds
    t_end = 15; % End time in seconds

    % Calculate corresponding indices
    start_index = round(t_start * Fs) + 1; % +1 because MATLAB indexes from 1
    end_index = round(t_end * Fs);

    % Extract samples
    x_original = x_original(start_index:end_index);
    N_original = length(x_original);
end
%% Multiple signal length handling


n_subs = round(N_original / step);
n_cols = ceil(sqrt(n_subs)); 
n_rows = ceil(n_subs / n_cols); 

for i = step:step:N_original

    x = x_original(1:i)-mean(x_original(1:i));
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;


    % %% Wavelet denoising
    x_w = denoise_ecg_wavelet(x, Fs, 'sym4', 9);

    %% Results
    figure(2)
    sgtitle('Scalogram of Original Signal')
    subplot(n_rows, n_cols, i/step)


    % Creazione del filtro CWT con i parametri ottimali
    fb = cwtfilterbank('SignalLength', N, ...
        'SamplingFrequency', Fs, ...
        'VoicesPerOctave', 12, ...
        'Wavelet', 'morse');

    % Calcolo dello scalogramma del segnale
    [coefficients, frequencies] = cwt(x, 'FilterBank', fb);

    contourf(t, frequencies, abs(coefficients).^2);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title([num2str(N)+ ' points']);
    colorbar;

    figure(3)
    sgtitle('Scalogram of Filtered Signal')
    subplot(n_rows, n_cols, i/step)


    % Creazione del filtro CWT con i parametri ottimali
    fb = cwtfilterbank('SignalLength', N, ...
        'SamplingFrequency', Fs, ...
        'VoicesPerOctave', 12, ...
        'Wavelet', 'morse');

    % Calcolo dello scalogramma del segnale
    [coefficients, frequencies] = cwt(x_w, 'FilterBank', fb);

    % Visualizzazione dello scalogramma (|coeff|^2)
    contourf(t, frequencies, abs(coefficients).^2);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title([num2str(N)+ ' points']);
    colorbar;

end

