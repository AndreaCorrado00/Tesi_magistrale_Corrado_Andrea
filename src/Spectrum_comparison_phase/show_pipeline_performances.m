function show_pipeline_performances(data)

% Extraction of signals
rov=data.rov_trace{:,1};
ref=data.ref_trace{:,1};
spare1=data.spare1_trace{:,1};
spare2=data.spare2_trace{:,1};
spare3=data.spare3_trace{:,1};

tab_signals=[rov,ref,spare1,spare2,spare3];
Fs=2035;
traces=["Rov trace","Ref trace","Spare1 trace","Spare2 trace","Spare3 trace"];

%% Filtering performances as suggested by originally evaluated pipeline
figure(1)
sgtitle('Filtering performances: Original pipeline')
for i=1:5
        x=tab_signals(:,i)-mean(tab_signals(:,i));
        % DWT Filtering
        x_w=handable_denoise_ecg_wavelet(x, Fs, 'sym4',9,false,40);
        % BP filtering
        x_BP=handable_denoise_ecg_BP(x, Fs,40);


        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;
        subplot(3,2,i)
        plot(t,x,'k:',t,x_w,'b-',t,x_BP,'r-')
        xlabel('Time [s]')
        ylabel(['Amplitude [mV]'])
        title(traces(i))
       

end
legend('Original', 'DWT filter','BP Filter',"Location","bestoutside")

%% Filtering performances using or not padding 
figure(2)
sgtitle('Padding presence comparison')
for i=1:5
        x=tab_signals(:,i)-mean(tab_signals(:,i));
        % DWT Filtering
        x_w=handable_denoise_ecg_wavelet(x, Fs, 'sym4',9,false,70);
        % BP filtering
        x_w_padded=handable_denoise_ecg_wavelet(x, Fs, 'sym4',9,true,70);


        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;
        subplot(3,2,i)
        plot(t,x,'k:',t,x_w,'b-',t,x_w_padded,'r-')
        xlabel('Time [s]')
        ylabel(['Amplitude [mV]'])
        title(traces(i))
       

end
legend('Original', 'DWT no padding','DWT padding',"Location","bestoutside")


%% Filtering performances with BP cutoff modified
BP_cut_freq=[40:10:90];
figure(3)
sgtitle('Different Cut-off frequences performances (Ref signal)')
for i=1:length(BP_cut_freq)
        x=ref-mean(ref);
        % DWT Filtering
        x_w=handable_denoise_ecg_wavelet(x, Fs, 'sym4',9,false,BP_cut_freq(i));
        % BP filtering
        x_BP=handable_denoise_ecg_BP(x, Fs,BP_cut_freq(i));


        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;

        subplot(3,3,i)
        plot(t,x,'k:',t,x_w,'b-',t,x_BP,'r-')
        xlabel('Time [s]')
        ylabel(['Amplitude [mV]'])
        title("Cut-off at: "+num2str(BP_cut_freq(i))+" Hz")

end
legend('Original', 'DWT filter','BP Filter',"Location","bestoutside")

%% FINAL CONFIGURATION performances 
figure(4)
% sgtitle({['{\bf\fontsize{14}' folderName '}'],fileName});
sgtitle({['{\bf\fontsize{14}' 'Filtering performances: Final pipeline' '}'],['Padding absent' newline 'Cut-off at 70 Hz']})
% subtitle(['Padding absent' newline 'Cut-off at 70 Hz']);
for i=1:5
        x=tab_signals(:,i)-mean(tab_signals(:,i));
        % DWT Filtering
        x_w=handable_denoise_ecg_wavelet(x, Fs, 'sym4',9,false,70);
        % BP filtering
        x_BP=handable_denoise_ecg_BP(x, Fs,70);


        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;
        subplot(3,2,i)
        plot(t,x,'k:',t,x_w,'b-',t,x_BP,'r-')
        xlabel('Time [s]')
        ylabel(['Amplitude [mV]'])
        title(traces(i))
       

end
legend('Original', 'DWT filter','BP Filter',"Location","bestoutside")

end
