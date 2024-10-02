function show_AR_model_performance(type)
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat");
switch type
    case "high_frequency_ecg"
        name="ecg with HF noise";
        ecg = ecg_simulation.high_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum
    case "Low_frequency_ecg"
        name="ecg with LF noise";
        ecg = ecg_simulation.low_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum

    case "PhysioNet_healthy"
        name="Healthy ecg from PhysioNet";
        ecg = ecg_simulation.healthy;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
    case "PhysioNet_Pathological"
        name="Pathological ecg from PhysioNet";
        ecg = ecg_simulation.patological;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
end

%% Starting of simulation
x_original = ecg - mean(ecg); % Subtract the mean

if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
    x_original = x_original / 1000;

    t_start = 5; % Start time in seconds
    t_end = 15; % End time in seconds

    % Calculate corresponding indices
    start_index = round(t_start * Fs) + 1; % +1 because MATLAB indexes from 1
    end_index = round(t_end * Fs);

    % Extract samples
    x_original = x_original(start_index:end_index);
end

%% Filtering signal
x_w=denoise_ecg_wavelet(x_original,Fs,'sym4',9);
x_w=x_w-mean(x_w);
N=length(x_w);
Ts = 1 / Fs;
t = 0:Ts:Ts*N-Ts;

%% AR estimation (YW)
p = 100;
th =  ar(x_w, p, 'yw');

a_yw=th.a;
%% Prediction error
err=filter(th.a,1,x_w);

%% Autocorrelation of the prediction error
tau_max=100;
Ry=stima_autocorr(err,tau_max);


%% AR spectrum estimation (yw)
[H, f] = freqz(1, th.a, N, Fs);
f_DSP = f;
DSP = th.NoiseVariance * (abs(H).^2);

%% AR spectrum estimation (burg)
p_ls =evaluate_order(x_w, 8, 14, 2, 6,'ls');
th= ar(x_w-mean(x_w), p, 'ls');
[H, f] = freqz(1, th.a, N, Fs);
f_ls = f;
DSP_ls = th.NoiseVariance * (abs(H).^2);
a_ls=th.a;



% Normalization
U=max(DSP)/max(DSP_ls);
DSP_ls=U.*DSP_ls;

%% Welch spectrum estimation
window = hamming(512); % Hamming window
noverlap = length(window) / 2; % overlapping
nfft = 2048; % Points of fft

% Welch periodogram
[pxx, f] = pwelch(x_w, window, noverlap, nfft, Fs);

% Normalization
U = max(DSP) / max(pxx);

pxx = U * pxx;

figure(1)
sgtitle("Prediction error and autocorrelation function: "+name)
subplot(311)
plot(t,err,'b-')
xlabel('time [s]')
ylabel('Prediction error [mV]')

subplot(312)
stem(0:tau_max,Ry,'bo')
title('Autocorrelation')
xlabel("\tau")
subplot(313)
title("Spectrum estimations, AR order: "+num2str(p))
hold on
plot(f, pxx,'Color',[0.8500 0.3250 0.0980],'LineWidth',0.5)
plot(f_DSP, DSP,'Color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
plot(f_ls, DSP_ls,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
hold off
ylabel('PSD')
xlabel('f [Hz]')
xlim([0, 60])
legend( 'Welch','AR YW estimation','AR LS estimation')






