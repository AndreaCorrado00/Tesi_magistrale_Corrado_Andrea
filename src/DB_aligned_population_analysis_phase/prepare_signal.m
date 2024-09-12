function new_signal=prepare_signal(signal)

signal=table2array(signal);
% Nan removal 
signal = signal(~isnan(signal));

new_signal=denoise_ecg_wavelet(signal,2035,'sym4',9);
new_signal=new_signal-mean(new_signal);

end
