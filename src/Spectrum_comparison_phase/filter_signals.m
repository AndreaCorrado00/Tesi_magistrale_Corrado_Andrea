function data_filtered=filter_signals(data)

data_filtered=data;
subjects=fieldnames(data);
for i=1:length(subjects)
    sub=string(subjects(i));
    %[M,N]=size(data.(sub).records_table);

    %% Filter proprieties
    Fc=data.(sub).fc; %Hz
    %% fixing filtering options
    % filter parameters in Hz
    Wp=50;%Hz
    Ws=55;
    Rp=0.98; % percentage
    Rs=0.01;
    % parameters conversions
    Wp=Wp/(Fc/2);
    Ws=Ws/(Fc/2);
    Rp=-20*log10(Rp);
    Rs=-20*log10(Rs);

    
    %% filter determination
    [n,Wp]=ellipord(Wp,Ws,Rp,Rs);
    [b,a]=ellip(n,Rp,Rs,Wp);
    % 
    % %% risposta in frequenza del filtro
    % [H,f]=freqz(b,a,512,Fc);
    % % mostriamola
    % figure(1)
    % subplot(211)
    % plot(f,abs(H))
    % 
    % grid on
    % title('Modulo del filtro')
    % 
    % subplot(212)
    % plot(f,angle(H))
    % grid on
    % title('Sfasamento ')
    data_filtered.(sub).lead_1_data=filter(b,a,data.(sub).lead_1_data-mean(data.(sub).lead_1_data));
    
end

end
