function filtData=apply_filter(data,show_filter_result)

filtData=data;
% Extraction of signals
rov=data.rov_trace{:,1};
ref=data.ref_trace{:,1};
spare1=data.spare1_trace{:,1};
spare2=data.spare2_trace{:,1};
spare3=data.spare3_trace{:,1};

tab_signals=[rov,ref,spare1,spare2,spare3];
Fs=2035;
traces=["Rov trace","Ref trace","Spare1 trace","Spare2 trace","Spare3 trace"];

figure(1)
sgtitle('Example of Wavelet + PB / PB denoising application') 

% Filter specifics 
wavelet_type='sym4';
n_levels=9;

% DWT Filter application
filtData.DWT.rov_trace=denoise_ecg_wavelet(rov-mean(rov), Fs, wavelet_type,n_levels);
filtData.DWT.ref_trace=denoise_ecg_wavelet(ref-mean(ref), Fs, wavelet_type,n_levels);
filtData.DWT.spare1_trace=denoise_ecg_wavelet(spare1-mean(spare1), Fs, wavelet_type,n_levels);
filtData.DWT.spare2_trace=denoise_ecg_wavelet(spare2-mean(spare2), Fs, wavelet_type,n_levels);
filtData.DWT.spare3_trace=denoise_ecg_wavelet(spare3-mean(spare3), Fs, wavelet_type,n_levels);
% BP Filter Application
filtData.BP.rov_trace=denoise_ecg_BP(rov-mean(rov), Fs);
filtData.BP.ref_trace=denoise_ecg_BP(ref-mean(ref), Fs);
filtData.BP.spare1_trace=denoise_ecg_BP(spare1-mean(spare1), Fs);
filtData.BP.spare2_trace=denoise_ecg_BP(spare2-mean(spare2), Fs);
filtData.BP.spare3_trace=denoise_ecg_BP(spare3-mean(spare3), Fs);


% Showing results if required
if show_filter_result
    for i=1:5
        x=tab_signals(:,i)-mean(tab_signals(:,i));
        % DWT Filtering
        x_w=denoise_ecg_wavelet(x, Fs, wavelet_type,n_levels);
        % BP filtering
        x_BP=denoise_ecg_BP(x, Fs);


        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;
        subplot(3,2,i)
        plot(t,x,'k:',t,x_w,'b-',t,x_BP,'r-')
        xlabel('Time [s]')
        ylabel(['Amplitude [mV]'])
        title(traces(i))
       

    end
end
legend('Original', 'DWT filter','BP Filter',"Location","bestoutside")
