function noise = extract_noise(low_band,high_band,Fs, x)
x = x-mean(x);
N = length(x);
Ts = 1 / Fs;
% t = 0:Ts:Ts*N-Ts;

%% Noise is extracted from x with:
Wn_low = low_band/ (Fs/2); 
[b_low, a_low] = butter(6, Wn_low, 'low');

Wn_high = high_band / (Fs/2);  
[b_high, a_high] = butter(6, Wn_high, 'high');

filtered_low = filtfilt(b_low, a_low, x);  
filtered_high = filtfilt(b_high, a_high, x); 

noise = filtered_low + filtered_high;

    % 
    % subplot(3, 1, 2);
    % plot(t,noise);
    % title('Noise extracted');
    % xlabel('time [s]');
    % ylabel('Amplitude [mV]');
    % 
    % subplot(313)
    % plot(t,noise,'k:',t,x_ref,'b-');
    % title('Noise and Reference Signal');
    % xlabel('time [s]');
    % ylabel('Amplitude [mV]');


end
    

