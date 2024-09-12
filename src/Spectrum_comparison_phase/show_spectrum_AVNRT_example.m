function show_spectrum_AVNRT_example(data)

% Extraction of signals filtered with DWT
rov=data.DWT.rov_trace(:,1);
ref=data.DWT.ref_trace(:,1);
spare1=data.DWT.spare1_trace(:,1);
spare2=data.DWT.spare2_trace(:,1);
spare3=data.DWT.spare3_trace(:,1);

tab_signals_DWT=[rov,ref,spare1,spare2,spare3];

% Extraction of signals filtered with BP
rov=data.BP.rov_trace(:,1);
ref=data.BP.ref_trace(:,1);
spare1=data.BP.spare1_trace(:,1);
spare2=data.BP.spare2_trace(:,1);
spare3=data.BP.spare3_trace(:,1);

tab_signals_PB=[rov,ref,spare1,spare2,spare3];

traces=["Rov trace","Ref trace","Spare1 trace","Spare2 trace","Spare3 trace"];
Fs=2035;

figure(2)
sgtitle('Power spectrum estimation, DWT filter signals')

for i=1:5
    x_w=tab_signals_DWT(:,i)-mean(tab_signals_DWT(:,i));
    N = length(x_w);

    %% AR spectrum estimation (ls)
    p = evaluate_order(x_w, 8, 20, 2, 6,'ls');
    th =  ar(x_w-mean(x_w), p, 'ls');
    [H, f] = freqz(1, th.a, N, Fs);
    f_DSP = f;
    DSP = th.NoiseVariance * (abs(H).^2);

    %% AR spectrum estimation (burg)
    p_bu =evaluate_order(x_w, 8, 16, 2, 7,'burg');
    th= ar(x_w-mean(x_w), p_bu, 'burg');
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
    subplot(3,2,i)
    hold on
    plot(f, pxx,'Color',[0.8500 0.3250 0.0980],'LineWidth',0.5)
    plot(f_S,S,'Color',[0.9290 0.6940 0.1250],'LineWidth',0.5)
    plot(f_DSP, DSP,'Color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
   % plot(f_BU, DSP_BU,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
    hold off
    ylabel('PSD')
    xlabel('f [Hz]')
    title(traces(i)+", p_{AR}(LS)=" + num2str(p)+", p_{AR}(BU)="+num2str(p_bu))
    xlim([0, 200])
    legend( 'Welch','FFT','AR LS estimation')
    hold on

end


figure(3)
sgtitle('Power spectrum estimation, BP filter signals')
for i=1:5
    x_w=tab_signals_PB(:,i)-mean(tab_signals_PB(:,i));
    N=length(x_w);
    %% AR spectrum estimation (ls)
    p = evaluate_order(x_w, 8, 20, 2, 6,'ls');
    th =  ar(x_w-mean(x_w), p, 'ls');
    [H, f] = freqz(1, th.a, N, Fs);
    f_DSP = f;
    DSP = th.NoiseVariance * (abs(H).^2);

    %% AR spectrum estimation (burg)
    p_bu =evaluate_order(x_w, 8, 16, 2, 7,'burg');
    th= ar(x_w-mean(x_w), p_bu, 'burg');
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
    subplot(3,2,i)
    hold on
    plot(f, pxx,'Color',[0.8500 0.3250 0.0980],'LineWidth',0.5)
    plot(f_S,S,'Color',[0.9290 0.6940 0.1250],'LineWidth',0.5)
    plot(f_DSP, DSP,'Color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
    %plot(f_BU, DSP_BU,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
    hold off
    ylabel('PSD')
    xlabel('f [Hz]')
    title(traces(i)+", p_{AR}(LS)=" + num2str(p)+", p_{AR}(BU)="+num2str(p_bu))
    xlim([0, 200])
    legend( 'Welch','FFT','AR LS estimation')
    hold on

end


end
