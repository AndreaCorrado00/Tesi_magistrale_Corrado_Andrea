function data_filtered=filter_signals(data)

data_filtered=data;
subjects=fieldnames(data);
for i=1:length(subjects)
    sub=string(subjects(i));
    [M,N]=size(data.(sub).records_table);

    %% Filter proprieties
    Fc=data.(sub).fc; %Hz
    %% fixing filtering options
    % filter parameters in Hz
    Wp=60;%Hz
    Ws=70;
    Rp=0.95; % percentage
    Rs=0.1;
    % parameters conversions
    Wp=Wp/(Fc/2);
    Ws=Ws/(Fc/2);
    Rp=-20*log10(Rp);
    Rs=-20*log10(Rs);

    %% filter determination
    [n,Wp]=ellipord(Wp,Ws,Rp,Rs);
    [b,a]=ellip(n,Rp,Rs,Wp);
    for j=1:M
        %% filtering signal
        data_filtered.(sub).records_table(j,:)=filter(b,a,data.(sub).records_table(j,:));
    end
    
end

end
