function show_scalogram_AVNRT_data(data)

% Data are expected to be the struct of only traces of a single subject,
% then the first record will be evaluated to provide an example


%% Starting of simulation

x_original = ecg - mean(ecg); % Subtract the mean
N_original = length(x_original);
disp( ' ')

if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
    %% Signal reduction (avoid artifacts)
    disp('      In this case, the signal is windowed to avoid artifacts')
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
    ylim([0,120])
    title([num2str(N)+ " points"]);
    colorbar;
    

end
figure(3)
sgtitle('Whole signal and scalogram');
% Whole signal and scalogram visualization
subplot(3,3,1:3)
plot(t,x)
ylabel('Amplitude [mV]')
subplot(3,3,4:9)
contourf(t, frequencies, abs(coefficients).^2);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim([0,120])

colorbar('Location','southoutside');