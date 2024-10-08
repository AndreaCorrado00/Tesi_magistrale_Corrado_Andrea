function noise = extract_noise(ecg_type, Fc, x)
x = x-mean(x);
N = length(x);
Ts = 1 / Fc;
t = 0:Ts:Ts*N-Ts;
    switch ecg_type
        case "high_frequency_ecg"
            [b, a] = butter(8, 50 / (Fc / 2), 'high');
            noise = filtfilt(b, a, x);

            x_ref=x-noise;
            [h, w] = freqz(b, a, 1024, Fc); 
            figure;
            subplot(3, 1, 1); 
            plot(w, abs(h));
            title('Frequency response - High-pass filter (60 Hz)');
            xlabel('F [Hz]');
            ylabel('Amplitude');
            grid on;

        case "Low_frequency_ecg"
            [b, a] = butter(6, 3 / (Fc / 2), 'low');
            noise = filtfilt(b, a, x);

            x_ref=x-noise;
            [h, w] = freqz(b, a, 1024, Fc);
            figure;
            subplot(3, 1, 1); 
            plot(w,abs(h));
            title('Frequency response - Low-pass filter (1 Hz)');
            xlabel('F [Hz]');
            ylabel('Amplitude');
            grid on;
    end

   
    subplot(3, 1, 2);
    plot(t,noise);
    title('Noise extracted');
    xlabel('time [s]');
    ylabel('Amplitude [mV]');

    subplot(313)
    plot(t,noise,'k:',t,x_ref,'b-');
    title('Noise and Reference Signal');
    xlabel('time [s]');
    ylabel('Amplitude [mV]');


end
    

