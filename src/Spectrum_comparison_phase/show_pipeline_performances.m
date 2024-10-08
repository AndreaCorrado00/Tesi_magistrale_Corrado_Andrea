function show_pipeline_performances(data)
% SHOW_PIPELINE_PERFORMANCES Evaluates and compares the performance of
% different filtering techniques on ECG signals.
%
% Inputs:
%   - data: A structure containing ECG signal traces. It should have
%           fields 'rov_trace', 'ref_trace', 'spare1_trace', 'spare2_trace',
%           and 'spare3_trace', each containing a cell array with signal data.
%
% Outputs:
%   - None
%
% Description:
%   This function visualizes the performance of various filtering methods
%   (Discrete Wavelet Transform (DWT) and Band-Pass (BP) filters) applied
%   to ECG signals. It includes comparisons with different settings and 
%   parameters.

% Extraction of signals from the input data structure
rov = data.rov_trace{:,1};
ref = data.ref_trace{:,1};
spare1 = data.spare1_trace{:,1};
spare2 = data.spare2_trace{:,1};
spare3 = data.spare3_trace{:,1};

tab_signals = [rov, ref, spare1, spare2, spare3];
Fs = 2035; % Sampling frequency
traces = ["Rov trace", "Ref trace", "Spare1 trace", "Spare2 trace", "Spare3 trace"];

% %% Filtering performances as suggested by originally evaluated pipeline
% figure(1)
% sgtitle('Filtering Performances: Original Pipeline')
% 
% for i = 1:5
%     x = tab_signals(:,i) - mean(tab_signals(:,i)); % Remove DC offset
% 
%     % DWT Filtering
%     x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, 40);
% 
%     % BP Filtering
%     x_BP = handable_denoise_ecg_BP(x, Fs, 40);
% 
%     % Plotting results
%     N = length(x);
%     Ts = 1 / Fs;
%     t = 0:Ts:Ts*N-Ts;
%     subplot(3,2,i)
%     plot(t, x, 'k:', t, x_w, 'b-', t, x_BP, 'r-')
%     xlabel('Time [s]')
%     ylabel('Amplitude [mV]')
%     title(traces(i))
% end
% legend('Original', 'DWT Filter', 'BP Filter', "Location", "bestoutside")

%% Filtering performances using or not padding 
figure(2)
sgtitle('Padding Presence Comparison')

for i = 1:5
    x = tab_signals(:,i) - mean(tab_signals(:,i)); % Remove DC offset

    % DWT Filtering without padding
    x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, 70);
    
    % DWT Filtering with padding
    x_w_padded = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, true, 70);
    
    % Plotting results
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;
    subplot(3,2,i)
    plot(t, x, 'k:', t, x_w, 'b-', t, x_w_padded, 'r-')
    xlabel('Time [s]')
    ylabel('Amplitude [mV]')
    title(traces(i))
end
legend('Original', 'DWT No Padding', 'DWT Padding', "Location", "bestoutside")

%% Filtering performances with BP cutoff modified
% BP_cut_freq = 40:10:90;
% figure(3)
% sgtitle('Different Cut-off Frequencies Performances (Rov Signal)')
% 
% for i = 1:length(BP_cut_freq)
%     x = rov - mean(rov); % Remove DC offset
% 
%     % DWT Filtering
%     x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, BP_cut_freq(i));
% 
%     % BP Filtering
%     x_BP = handable_denoise_ecg_BP(x, Fs, BP_cut_freq(i));
% 
%     % Plotting results
%     N = length(x);
%     Ts = 1 / Fs;
%     t = 0:Ts:Ts*N-Ts;
%     subplot(3,3,i)
%     plot(t, x, 'k:', t, x_w, 'b-', t, x_BP, 'r-')
%     xlabel('Time [s]')
%     ylabel('Amplitude [mV]')
%     title("Cut-off at: " + num2str(BP_cut_freq(i)) + " Hz")
% end
% legend('Original', 'DWT Filter', 'BP Filter', "Location", "bestoutside")

%% FINAL CONFIGURATION Performances 
figure(4)
sgtitle({'Filtering Performances: Final Pipeline', 'sym4 wavelet, BP 3-60 Hz'})

for i = 1:5
    x = tab_signals(:,i) - mean(tab_signals(:,i)); % Remove DC offset
    
    % DWT Filtering
    x_w = handable_denoise_ecg_wavelet(x, Fs, 'sym4', 9, false, 60);
    
    % BP Filtering
    x_BP = handable_denoise_ecg_BP(x, Fs, 60);
    
    % Plotting results
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;
    subplot(3,2,i)
    % plot(t, x, 'k:', t, x_w, 'b-', t, x_BP, 'r-')
    plot(t, x, 'k:', t, x_w, 'b-')
    xlabel('Time [s]')
    ylabel('Amplitude [mV]')
    title(traces(i))
end
% legend('Original', 'DWT Filter', 'BP Filter', "Location", "bestoutside")
legend('Original', 'DWT Filter', "Location", "bestoutside")

end
