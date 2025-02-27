function show_spectrum_evaluation_pipeline(type)
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")

% switch type
%     case "high_frequency_ecg"
%         name="ECG with high frequency noise";
%         ecg = ecg_simulation.high_freq;
%         Fs = 1000; % Hz
%         step = 1000; % Increment of points from which to evaluate the spectrum
%     case "Low_frequency_ecg"
%         name="ECG with low frequency noise";
%         ecg = ecg_simulation.low_freq;
%         Fs = 1000; % Hz
%         step = 1000; % Increment of points from which to evaluate the spectrum
% 
%     case "PhysioNet_healthy"
%         name="Healthy subject Physionet DB";
%         ecg = ecg_simulation.healthy;
%         Fs = 360; % Hz
%         step = 720; % Increment of points from which to evaluate the spectrum
%     case "PhysioNet_Pathological"
%         name="Pathological subject Physionet DB";
%         ecg = ecg_simulation.patological;
%         Fs = 360; % Hz
%         step = 720; % Increment of points from which to evaluate the spectrum
% end
% ECG parameters
Fs = 1000;           % F sampling(Hz)
step=2000;
duration = 1;        % Duration (s)
t = 0:1/Fs:duration; 

% 30 seconds of Synthetic ECG
ecg_signal = ecg(length(t));

ecg_signal = repmat(ecg_signal, 1, 10); % ten beats
ecg_signal = sgolayfilt(ecg_signal, 2, 31);
ecg_signal = ecg_signal - mean(ecg_signal);

N = length(ecg_signal);
Ts = 1 / Fs;
t = 0:Ts:Ts*N - Ts;

switch type
    case "high_frequency_ecg"
        var_noise = 0.002;
        noise = sqrt(var_noise) * randn(1, N);
        ecg_x = ecg_signal + noise;

        noise_title = "ECG with white, Gaussian noise \sigma^{2} =" + num2str(var_noise);
    case "Low_frequency_ecg"
        % Frequencies of sinusoids
        f1 = 0.166;    % Frequency of first sinusoid (Hz)
        f2 = 0.332;    % Frequency of second sinusoid (Hz)

        % Amplitudes of sinusoids
        A1 = 0.1;      % Amplitude of first sinusoid
        A2 = 0.1;      % Amplitude of second sinusoid

        % Generate the sinusoids
        noise = A1 * sin(2 * pi * f1 * t) + A2 * sin(2 * pi * f2 * t) + sqrt(0.002) * randn(1, N);
        
        ecg_x = ecg_signal + noise;
        noise_title = "Baseline drift noise ";
end

%% Starting of simulation
x_original = ecg_x - mean(ecg_x); % Subtract the mean
N_original = length(x_original);

% if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
%     %% Signal reduction (avoid artifacts)
%     x_original = x_original / 1000;
% 
%     t_start = 10; % Start time in seconds
%     t_end = 20; % End time in seconds
% 
%     % Calculate corresponding indices
%     start_index = round(t_start * Fs) + 1; % +1 because MATLAB indexes from 1
%     end_index = round(t_end * Fs);
% 
%     % Extract samples
%     x_original = x_original(start_index:end_index);
%     N_original = length(x_original);
% end
%% Multiple signal length handling

n_subs = round(N_original / step);
n_cols = ceil(sqrt(n_subs)); 
n_rows = ceil(n_subs / n_cols); 

for i = step:step:N_original

    x = x_original(1:i)-mean(x_original(1:i));
    N = length(x);
    Ts = 1 / Fs; 
    t = 0:Ts:Ts*N-Ts;

    x_w=x;
    %% Digital filter
    % x_f_2=handable_denoise_ecg_BP(x,Fs,60);
    %% Wavelet denoising
    % x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9,false,40);
    

    % %% AR spectrum estimation (ls)
    % p = evaluate_order(x_w, 8, 14, 2, 6,'ls');
    % th =  ar(x_w-mean(x_w), p, 'ls');
    % [H, f] = freqz(1, th.a, N, Fs); 
    % f_DSP = f;
    % DSP = th.NoiseVariance * (abs(H).^2);
    % 
    % %% AR spectrum estimation (burg)
    % p_bu =evaluate_order(x_w, 8, 14, 2, 6,'burg');
    % th= ar(x_w-mean(x_w), p_bu, 'burg');
    % [H, f] = freqz(1, th.a, N, Fs); 
    % f_BU = f;
    % DSP_BU = th.NoiseVariance * (abs(H).^2);

    
    % Normalization
    % U=max(DSP)/max(DSP_BU);
    % DSP_BU=U.*DSP_BU;

    %% Welch spectrum estimation
    window = hamming(512); % Hamming window
    noverlap = length(window) / 2; % overlapping
    nfft = 2048; % Points of fft

    % Welch periodogram
    [pxx, f] = pwelch(x_w, window, noverlap, nfft, Fs);

    % Normalization
    % U = max(DSP) / max(pxx); 
    % 
    % pxx = U * pxx;

    %% Spectrogram estimation
    FT_x=fft(x_w,N);
    S=abs(FT_x).^2/N;
    f_S=0:Fs/N:Fs-Fs/N;

    % Normalization
    % U=max(DSP)/max(S);
    % S=U.*S;
    U=max(pxx)/max(S);
    S=U.*S;


    %% Results
    figure(1)
    sgtitle("Power spectrum estimation on synthetic data: "+noise_title,"FontSize",24)
    subplot(n_rows, n_cols, i/step)
    hold on
    plot(f_S, S, 'Color', [0.7 0.4 0.7], 'LineWidth', 1.2)
    plot(f, pxx,'Color',[0 0.4470 0.7410],'LineWidth',1.2)
    % 
    % plot(f_DSP, DSP,'Color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
    % plot(f_BU, DSP_BU,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
    hold off
    ylabel('PSD','FontSize',14)
    xlabel('f [Hz]',"FontSize",14) 
    % title("N: " + num2str(N) + ", p_{AR}(LS)=" + num2str(p)+", p_{AR}(BU)="+num2str(p_bu))
    title("N points: " + num2str(N),"FontSize",16)
    xlim([0, 50])
    % legend( 'Welch','FFT','AR LS estimation','AR Burg estimation')
    legend('P_{S}','P_{W}',"FontSize",14)
end

% %% Different order comparison
% p_candidates=[6:1:14];
% 
% %% Spectrogram estimation
% FT_x=fft(x_w,N);
% S=abs(FT_x).^2/N;
% f_S=0:Fs/N:Fs-Fs/N;
% 
% 
% 
% %% Welch spectrum estimation
% window = hamming(512); % Hamming window
% noverlap = length(window) / 2; % overlapping
% nfft = 2048; % Points of fft
% % Welch periodogram
% [pxx, f_w] = pwelch(x_w, window, noverlap, nfft, Fs);

% %% Orders comparison
% 
% figure(3)
% title('AR Spectrums comparison')
% ylabel('PSD')
% xlabel('f [Hz]')
% xlim([0, 60])
% 
% hold on
% 
% legend_entries={};
% for k=1:length(p_candidates)
%     p=p_candidates(k);
% 
%     %% AR spectrum estimation 
%     th = ar(x_w, p, 'burg');
%     [H, f] = freqz(1, th.a, N, Fs); 
%     f_DSP = f;
%     DSP = th.NoiseVariance * (abs(H).^2);
% 
% 
%     % plots
% 
%     plot(f_DSP,DSP,'LineWidth',0.8)
% 
%     legend_entries{k}="AR order = "+num2str(p);
% 
% end
% % Normalization
% U = max(DSP) / max(pxx);
% pxx = U * pxx;
% 
% % Normalization
% U=max(DSP)/max(S);
% S=U.*S;
% 
% plot(f_w,pxx,'b--',f_S,S,'k:')
% legend_entries{k+1}="Welch";
% legend_entries{k+2}="Spectrogram";
% legend(legend_entries)
% hold off
% 
