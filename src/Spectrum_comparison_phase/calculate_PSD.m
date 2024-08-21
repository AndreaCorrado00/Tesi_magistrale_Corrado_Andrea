function DSP=calculate_PSD(signal, Fc)
% Convert signals to power spectrum
p=evaluate_order(signal,5,50,2,0.05);
th=ar(signal-mean(signal),p,'ls');
[H,~]=freqz(1,th.a,length(signal),Fc);
DSP=(abs(H).^2)*th.NoiseVariance;
