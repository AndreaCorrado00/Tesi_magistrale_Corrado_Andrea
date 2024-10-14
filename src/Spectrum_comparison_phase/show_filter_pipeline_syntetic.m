function show_filter_pipeline_syntetic(noise_type)
%load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat") 

%% Building the ground truth
% ECG parameters
Fs = 1000;           % F sampling(Hz)
duration = 1;       % Duration (s)
t = 0:1/Fs:duration; 

% 30 seconds of Syntetic ECG
ecg_signal = ecg(length(t));

ecg_signal=repmat(ecg_signal,1,25);
ecg_signal=sgolayfilt(ecg_signal,2,31);
ecg_signal=ecg_signal-mean(ecg_signal);

N = length(ecg_signal);
Ts = 1 / Fs;
t = 0:Ts:Ts*N-Ts;

switch noise_type
    case "white_noise_stationary_var_fix"
        var_noise=0.002;
        noise=sqrt(var_noise) * randn(1, N);
        noisy_ecg=ecg_signal+noise;

        noise_title="White,  gaussian noise with variance "+ num2str(var_noise);
    case "baseline_drift"
        % Frequenze delle sinusoidi
        f1 = 0.166;    % Frequenza della prima sinusoide (Hz)
        f2 = 0.332;  % Frequenza della seconda sinusoide (Hz)

        % Amplitudini delle sinusoidi
        A1 = 0.1;  % Ampiezza della prima sinusoide
        A2 = 0.1;  % Ampiezza della seconda sinusoide

        % Generazione delle sinusoidi
        noise = A1 * sin(2 * pi * f1 * t) + A2 * sin(2 * pi * f2 * t)+sqrt(0.002)*randn(1,N);
        
        noisy_ecg=ecg_signal+noise;
        noise_title="Baseline drift simulation ";
     
end

figure(1)
subplot(311)
plot(t,ecg_signal)
xlim([0,t(end)])
title('Reference')
subplot(312)
plot(t,noise)
xlim([0,t(end)])
title(noise_title)
subplot(313)
plot(t, noisy_ecg)
xlim([0,t(end)])
title('Noisy reference')
xlabel('Time [s]')

%% Starting of simulation
N_original = length(noisy_ecg);


N_points=[1000,N_original];

% for each ECG (n° beats) length the proposed pipeline is evaluated
for i = 1: length(N_points)
    lim=N_points(i);
    ref_win=ecg_signal(1:lim)-mean(ecg_signal(1:lim));
    noise_win=noise(1:lim)-mean(noise(1:lim));
    x = noisy_ecg(1:lim)-mean(noisy_ecg(1:lim));
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;

    x_w=handable_denoise_ecg_wavelet(x,Fs,'sym4',9,false,1,60);
    x_w=x_w-mean(x_w);
    x_bp=handable_denoise_ecg_BP(x,Fs,1,60);
    x_bp=x_bp-mean(x_bp);

    % SNR evaluation
    % Noise
    P_noise_original=sum(noise_win.^2);
    P_noise_residual_w=sum((x_w-ref_win).^2);
    P_noise_residual_bp=sum((x_bp-ref_win).^2);
    % Signal
    P_ref_win=sum(ref_win.^2);
    P_w=sum(x_w.^2);
    P_bp=sum(x_bp.^2);

    SNR_original= 10*log10(P_ref_win/P_noise_original);
    SNR_wavelet= 10*log10(P_w/P_noise_residual_w);
    SNR_bandpass= 10*log10(P_bp/P_noise_residual_bp);


    figure(i+1)
    hold on
    sgtitle("Denoising pipeline, N° points: "+num2str(N_points(i)))
    plot(t,x,"Color",[.5,.5,.5],"LineStyle",":","LineWidth",0.5)
    plot(t,ref_win,"Color",[.3,.3,.3],"LineWidth",0.7)
    plot(t,x_bp,"Color",[0.9290 0.6940 0.1250],"LineWidth",0.9)
    plot(t,x_w,"Color",	"#0072BD","LineWidth",0.9)
    xlabel('time [s]')
    ylabel('Amplitude [mV]')
    xlim([0,t(end)])
    
    % Add SNR values as annotations
    annotation('textbox', [0.85, 0.5, 0.1, 0.1], 'String', ...
        {['SNR Original: ', num2str(SNR_original, '%.2f'), ' dB'], ...
         ['SNR Bandpass: ', num2str(SNR_bandpass, '%.2f'), ' dB'], ...
         ['SNR Wavelet: ', num2str(SNR_wavelet, '%.2f'), ' dB']}, ...
        'FitBoxToText', 'on', 'BackgroundColor', 'w', 'EdgeColor', 'k', 'FontSize', 10);
    hold off
    legend(["Noisy signal","Ground truth","BP digital","Wavalet th + BP digital"],"Location","bestoutside")
end
