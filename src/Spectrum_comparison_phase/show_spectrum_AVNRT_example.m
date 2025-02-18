function show_spectrum_AVNRT_example(data, subject_name,record_id)
% SHOW_SPECTRUM_AVNRT_EXAMPLE Compares and plots the power spectrum of
% signals filtered with both DWT and BP filters.
%
% Inputs:
%   - data: A structure containing signals filtered with both DWT and BP
%           filters. Fields should include 'DWT' and 'BP' with respective
%           traces.
%
% Outputs:
%   - None
%
% Description:
%   This function extracts and processes signals filtered using DWT and BP
%   methods from the provided data structure. It compares their power spectra
%   using AR estimation, Welch periodogram, and FFT.


% Extraction of signals filtered with DWT
rov=data.rov_trace{:,record_id};
ref=data.ref_trace{:,record_id};
spare1=data.spare1_trace{:,record_id};
spare2=data.spare2_trace{:,record_id};
spare3=data.spare3_trace{:,record_id};

tab_signals_DWT=[rov,ref,spare1,spare2,spare3];

traces=["Rov trace","Ref trace","Spare1 trace","Spare2 trace","Spare3 trace"];
Fs=2035;
figure(1)
sgtitle(subject_name+", record "+record_id)

for i=1:5
    x_w=tab_signals_DWT(:,i)-mean(tab_signals_DWT(:,i));
    N = length(x_w);
    t=0:1/2035:N/2035 - 1/2035;
    


    %% Results
    subplot(3,2,i)
    hold on
    plot(t,x_w,'LineWidth',1)
  
    hold off
    ylabel('Amplitude [mV]')
    xlabel('t [s]')
    title(traces(i))
    xlim([0, 1])
    hold on

end


figure(2)
sgtitle("Power spectrum estimation: "+subject_name+", record "+record_id)

for i=1:5
    x_w=tab_signals_DWT(:,i)-mean(tab_signals_DWT(:,i));
    N = length(x_w);

    %% Welch spectrum estimation
    window = hamming(512); % Hamming window
    noverlap = length(window) / 2; % overlapping
    nfft = 2048; % Points of fft

    % Welch periodogram
    [pxx, f] = pwelch(x_w, window, noverlap, nfft, Fs);

    %% Spectrogram estimation
    FT_x=fft(x_w,N);
    S=abs(FT_x).^2/N;
    f_S=0:Fs/N:Fs-Fs/N;

    % Normalization
    U=max(pxx)/max(S);
    S=U.*S;


    %% Results
    subplot(3,2,i)
    hold on
    plot(f_S,S,'Color',[0.4940 0.1840 0.5560],'LineWidth',0.5)
    plot(f, pxx,'Color',[0 0.4470 0.7410],'LineWidth',0.5)
    hold off
    ylabel('PSD')
    xlabel('f [Hz]')
    title(traces(i))
    xlim([0, 300])
    legend( 'P_{S}','P_{W}')
    hold on

end


end
