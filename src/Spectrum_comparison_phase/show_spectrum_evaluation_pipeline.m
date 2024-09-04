function show_spectrum_evaluation_pipeline(type)
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
%pause(1)
disp( ' ')
disp("1. Now you'll see a signal of increasing length which will be filtered" + ...
    " using a numerical filter pipeline and a mixed wavelet-numerical one.")
disp("   Wavelet-numerical is the chosen one to proceed with the spectrum evaluation. Then:")
disp("   - Spectrum is evaluated with AR method and compared with the Welch spectrum. Each time the order of the AR is evaluated.")
disp("   - Results of spectrum evaluations can be seen in figure 2, while in figure 1 there will be the signal.")

%pause(10)

n_subs = round(N_original / step);
n_cols = ceil(sqrt(n_subs)); 
n_rows = ceil(n_subs / n_cols); 

for i = step:step:N_original

    x = x_original(1:i);
    N = length(x);
    Ts = 1 / Fs; 
    t = 0:Ts:Ts*N-Ts; 
    
    %% Numerical filter
    % % High pass
    % Wp = 0.5; % Hz
    % Ws = (Wp - Wp / 4);
    % 
    % Rp = 0.90; % percentage
    % Rs = 0.10;
    % 
    % % Parameters conversion
    % Wp = Wp / (Fs / 2);
    % Ws = Ws / (Fs / 2);
    % Rp = -20 * log10(Rp);
    % Rs = -20 * log10(Rs);
    % 
    % % Filter evaluation
    % [n, Wn] = ellipord(Wp, Ws, Rp, Rs);
    % [b, a] = ellip(n, Rp, Rs, Wn, "high");
    % x_f_1 = filter(b, a, x);
    % 
    % % Low pass
    % Wp = 80; % Hz
    % Ws = 100;
    % Rp = 0.95; 
    % Rs = 0.1;
    % 
    % Wp = Wp / (Fs / 2);
    % Ws = Ws / (Fs / 2);
    % Rp = -20 * log10(Rp);
    % Rs = -20 * log10(Rs);
    % 
    % 
    % [n, Wp] = ellipord(Wp, Ws, Rp, Rs);
    % [b, a] = ellip(n, Rp, Rs, Wp, 'low');
    % x_f_2 = filter(b, a, x_f_1);


    % High pass filter
    [b, a] = butter(6, 1 / (Fs / 2), 'high');
    x_denoised = filtfilt(b, a, x);

    % Low pass filter
    [b, a] = butter(8, 40 / (Fs / 2), 'low');
    x_f_2 = filtfilt(b, a, x_denoised);

    %% Wavelet denoising
    x_w = denoise_ecg_wavelet(x, Fs, 'sym4', 9);
    
    %% Filters comparison
    figure(1)
    title("Number of points: " + num2str(i))
    subplot(211)
    plot(t, x, 'k:', t, x_f_2, 'r', t, x_w, 'b')
    legend('original', 'numeric', 'wavelet')
    ylabel('Amplitude [mV]')

    subplot(212)
    plot(t, x, 'k:', t, x_f_2, 'r', t, x_w, 'b')
    xlim([0 1])
    xlabel('time[s]')
    ylabel('Amplitude [mV]')

    %% AR spectrum estimation (YW)
    disp('AR YW')
    p = evaluate_order(x_w, 40, 60, 2, 0.5);
    th = ar(x_w, p, 'yw');
    [H, f] = freqz(1, th.a, N, Fs); 
    f_DSP = f;
    DSP = th.NoiseVariance * (abs(H).^2);

    %% AR spectrum estimation (burg)
    disp('AR burg')
    p_bu = evaluate_order(x_w, 8, 14, 2, 3);
    th = ar(x_w, p_bu, 'burg');
    [H, f] = freqz(1, th.a, N, Fs); 
    f_BU = f;
    DSP_BU = th.NoiseVariance * (abs(H).^2);

    % Normalization
    U=max(DSP)/max(DSP_BU);
    DSP_BU=U.*DSP_BU;

    %% Welch spectrum estimation
    window = hamming(512); % Hamming window
    noverlap = length(window) / 2; % overlapping
    nfft = 2048; % Points of fft

    % Welch periodogram
    [pxx, f] = pwelch(x_w, window, noverlap, nfft, Fs);

    % Normalization
    U = max(DSP) / max(pxx); 

    pxx = U * pxx;

    %% Spectrogram estimation
    FT_x=fft(x_w,N);
    S=abs(FT_x).^2/N;
    f_S=0:Fs/N:Fs-Fs/N;

    % Normalization
    U=max(DSP)/max(S);
    S=U.*S;


    %% Results
    figure(2)
    sgtitle('Power spectrum estimation')
    subplot(n_rows, n_cols, i/step)
    hold on
    plot(f, pxx,'Color',[0.8500 0.3250 0.0980],'LineWidth',0.5)
    plot(f_S,S,'Color',[0.9290 0.6940 0.1250],'LineWidth',0.5)
    plot(f_DSP, DSP,'Color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
    plot(f_BU, DSP_BU,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
    hold off
    ylabel('PSD')
    xlabel('f [Hz]')
    title("N: " + num2str(N) + ", p_{AR}(YW)=" + num2str(p)+", p_{AR}(BU)="+num2str(p_bu))
    xlim([0, 60])
    legend( 'Welch','FFT','AR YW estimation','AR Burg estimation')
end

% %% Different order comparison
% p_candidates=[10:50:160];
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
% 
% 
% 
% 
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
%     th = ar(x_w, p, 'yw');
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

