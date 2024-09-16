function show_scalogram_evaluation_pipeline(type)
    % Function to demonstrate a pipeline for generating and evaluating ECG scalograms
    % with varying lengths of signal segments and different types of ECG signals.
    %
    % INPUT:
    %   type - Specifies the type of ECG signal to use (high_frequency_ecg, Low_frequency_ecg, PhysioNet_healthy, PhysioNet_Pathological)
    %
    % OUTPUT:
    %   None. The function displays figures showing the scalograms of ECG signals.

    % Load the dataset
    load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")

    % Display description
    disp('This code shows a proposed pipeline to obtain ECG scalograms');
    disp('using directly the original signal (zero mean) and varying the number of points of evaluation');

    % Select the ECG signal and parameters based on the input type
    switch type
        case "high_frequency_ecg"
            disp('Simulation of Spectrum evaluation pipeline on a signal with High Frequency Noise');
            ecg = ecg_simulation.high_freq;
            Fs = 1000; % Sampling frequency in Hz
            step = 1000; % Increment of points from which to evaluate the spectrum
        case "Low_frequency_ecg"
            disp('Simulation of Spectrum evaluation pipeline on a signal with Low Frequency Noise');
            ecg = ecg_simulation.low_freq;
            Fs = 1000; % Sampling frequency in Hz
            step = 1000; % Increment of points from which to evaluate the spectrum
        case "PhysioNet_healthy"
            disp('Simulation of Spectrum evaluation pipeline on a signal from PhysioNet DB of a healthy subject');
            ecg = ecg_simulation.healthy;
            Fs = 360; % Sampling frequency in Hz
            step = 720; % Increment of points from which to evaluate the spectrum
        case "PhysioNet_Pathological"
            disp('Simulation of Spectrum evaluation pipeline on a signal from PhysioNet DB of a pathological subject');
            ecg = ecg_simulation.patological;
            Fs = 360; % Sampling frequency in Hz
            step = 720; % Increment of points from which to evaluate the spectrum
    end

    %% Starting of simulation
    x_original = ecg - mean(ecg); % Zero-mean the signal
    N_original = length(x_original);
    disp(' ')

    % If the type is "PhysioNet_healthy" or "PhysioNet_Pathological", window the signal to avoid artifacts
    if strcmp(type, "PhysioNet_healthy") || strcmp(type, "PhysioNet_Pathological")
        disp('      In this case, the signal is windowed to avoid artifacts');
        x_original = x_original / 1000;

        t_start = 5; % Start time in seconds
        t_end = 15; % End time in seconds

        % Calculate corresponding indices
        start_index = round(t_start * Fs) + 1; % MATLAB indexes from 1
        end_index = round(t_end * Fs);

        % Extract samples
        x_original = x_original(start_index:end_index);
        N_original = length(x_original);
    end

    %% Handle multiple signal lengths
    n_subs = round(N_original / step);
    n_cols = ceil(sqrt(n_subs)); 
    n_rows = ceil(n_subs / n_cols); 

    for i = step:step:N_original
        x = x_original(1:i) - mean(x_original(1:i));
        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;

        %% Results
        figure(2)
        sgtitle('Scalogram of Original Signal')
        subplot(n_rows, n_cols, i/step)

        % Create CWT filter bank with optimal parameters
        fb = cwtfilterbank('SignalLength', N, ...
            'SamplingFrequency', Fs, ...
            'VoicesPerOctave', 12, ...
            'Wavelet', 'morse');

        % Calculate the scalogram of the signal
        [coefficients, frequencies] = cwt(x, 'FilterBank', fb);

        % Plot the scalogram
        contourf(t, frequencies, abs(coefficients).^2);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        ylim([0, 120])
        title([num2str(N) + " points"]);
        colorbar;
    end

    figure(3)
    sgtitle('Whole signal and scalogram');
    % Whole signal and scalogram visualization
    subplot(3, 3, 1:3)
    plot(t, x)
    ylabel('Amplitude [mV]')
    subplot(3, 3, 4:9)
    contourf(t, frequencies, abs(coefficients).^2);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    ylim([0, 120])
    colorbar('Location', 'southoutside');
end
