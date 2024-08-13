function data_filtered=filter_signals(data)

data_filtered=data;
subjects=fieldnames(data);
for i=1:length(subjects)
    sub=string(subjects(i));
    %[M,N]=size(data.(sub).records_table);

    %% Filter proprieties
    Fc=data.(sub).fc; %Hz

    %% fixing filtering options: Band Pass
  
    % Wp = [1 40] / (Fc / 2);  % Banda passante normalizzata (da 0.5 Hz a 40 Hz)
    % Rp = 0.95;  % Ripple nella banda passante (dB)
    % Ws = [0.1 60] / (Fc / 2);  % Frequenze di stop normalizzate (un po' più ampie per transizione)
    % Rs = 0.1;   % Attenuazione nella banda eliminata (dB)
    % 
    % Rp=-20*log10(Rp);
    % Rs=-20*log10(Rs);
    % [n, Wn] = cheb1ord(Wp, Ws, Rp, Rs);  % Ordine e frequenze del filtro
    % [b, a] = cheby1(n, Rp, Wn,"high");  % Coefficienti del filtro di Chebyshev di tipo I

    Wp=0.5;%Hz
    Ws=(Wp-Wp/4); %da progetto la banda di transizione deve essere pari a 1/4 di Wp
    % quindi Wp-Ws=1/4Wp => Ws=Wp-1/4Wp

    Rp=0.90; % in percentuale
    Rs=0.10;


    %% Parametri convertiti
    Wp=Wp/(Fc/2);
    Ws=Ws/(Fc/2);
    Rp=-20*log10(Rp);
    Rs=-20*log10(Rs);

    %% determinazione del filtro
    [n,Wn]=ellipord(Wp,Ws,Rp,Rs); %la frequenza di taglio coincede con quella di
    %inizio banda oscura per una
    % decisione implementativa interna di
    % matlab. In genere, anche nella teoria, è
    % così.
    [b,a]=ellip(n,Rp,Rs,Wn,"high");
    %% risposta in frequenza del filtro
    [H,f]=freqz(b,a,512,Fc);
    % mostriamola
    figure(2)
    subplot(211)
    plot(f,abs(H))

    grid on
    title('Elliptical High Pass Filter')
    ylabel('Magnitude')
    subplot(212)
    plot(f,angle(H))
    grid on
    ylabel('Phase')
    xlabel('Normalized frequency')
    data_filtered.(sub).lead_1_data=filter(b,a,data.(sub).lead_1_data-mean(data.(sub).lead_1_data));
    
end

end
