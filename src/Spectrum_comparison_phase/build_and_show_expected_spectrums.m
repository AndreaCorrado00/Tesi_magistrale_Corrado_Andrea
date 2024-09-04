function build_and_show_expected_spectrums()

load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")
ecg = ecg_simulation.low_freq;
Fs = 1000; % Hz
step = 1000; % Increment of points from which to evaluate the spectrum


%% Starting of simulation
x= ecg - mean(ecg); % Subtract the mean

%% Multiple signal length handling

x_w = denoise_ecg_wavelet(x, Fs, 'sym4', 9);

%% Single beat extraction
x=x(1:1000);
x_w=x_w(1:1000);

N= length(x);
Ts = 1 / Fs; 
t = 0:Ts:Ts*N-Ts;
%% Showing the single beat
figure(1)
sgtitle('Single beat of ecg signal and single waves')

subplot(411)
plot(t, x, 'k:', t, x_w, 'b')
legend('Original Single Beat','Denoised Single Beat')
ylabel('Amplitude [mV]')


%% Manual elimination of P,QRS, T waves
% P wave between 0.127 and  0.228 sec
ind_start_P=find(t==0.127);
ind_end_P=find(t==0.228);

% QRS between 0.228 and 0.432
ind_start_QRS=find(t==0.228);
ind_end_QRS=find(t==0.444);

% T wave between 0.432 and 0.672
ind_start_T=find(t==0.444);
ind_end_T=find(t==0.673);

% Building syntetic curves
ecg_P=x_w;
ecg_P(ind_start_QRS:ind_end_QRS)=x_w(ind_start_QRS);
ecg_P(ind_start_T:ind_end_T)=x_w(ind_start_T);

ecg_QRS=x_w;
ecg_QRS(ind_start_P:ind_end_P)=x_w(ind_start_P);
ecg_QRS(ind_start_T:ind_end_T)=x_w(ind_start_T);

ecg_T=x_w;
ecg_T(ind_start_P:ind_end_P)=x_w(ind_start_P);
ecg_T(ind_start_QRS:ind_end_QRS)=x_w(ind_start_QRS);

%% Showing new, syntetic, data
subplot(412)
title('Single waves of the signal')
plot(t, ecg_P,'b')
legend('P wave')
ylim([-0.6,3.8])
ylabel('Amplitude [mV]')
subplot(413)
plot(t,ecg_QRS,'r')
ylabel('Amplitude [mV]')
ylim([-0.6,3.8])
legend('QRS')

subplot(414)
plot(t,ecg_T,'g')
ylabel('Amplitude [mV]')
legend('T wave')
ylim([-0.6,3.8])
xlabel('Time [s]')


%% Building the spectrum plot
signals=[ecg_P,ecg_QRS,ecg_T];
colors=["b","r","g"];

figure(2)
hold on
sgtitle('Evaluation of single waves spectrums')
xlabel('f[Hz]')
ylabel('Amplitude')
xlim([0,60])

for i=1:3
    x_w=signals(:,i)-mean(signals(:,i));
    color=colors(i);

    p=10;

    th = ar(x_w, p, 'burg');
    [H, f] = freqz(1, th.a, N, Fs);
    f_BU = f;
    DSP_BU = th.NoiseVariance * (abs(H).^2);
    
    plot(f_BU,DSP_BU,'Color',color,"LineWidth",1.5)
end
legend('P wave spectrum', 'QRS spectrum','T wave spectrum')
hold off

