function [DSP,f]=calculate_PSD(signal, Fc)
% Convert signals to power spectrum
p=evaluate_order(signal,1,30,1,10);
th=ar(signal-mean(signal),p,'yw');
[H,f]=freqz(1,th.a,length(signal),Fc);
DSP=(abs(H).^2)*th.NoiseVariance;

% p=50;
% th=ar(x,p,'yw'); %identifichiamo un autoreversivo sui nostri dati di ordine 30
% [H,f]=freqz(1,th.a,N,Fs); %risposta in frequenza del modello usato per la stima
% f_DSP=f;
% DSP=(abs(H).^2)*th.NoiseVariance;